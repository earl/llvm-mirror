import multiprocessing
import time

import lit.Test
import lit.util
import lit.worker

# No-operation semaphore for supporting `None` for parallelism_groups.
#   lit_config.parallelism_groups['my_group'] = None
class NopSemaphore(object):
    def acquire(self): pass
    def release(self): pass

class Run(object):
    """
    This class represents a concrete, configured testing run.
    """

    def __init__(self, lit_config, tests):
        self.lit_config = lit_config
        self.tests = tests

    def execute_tests(self, progress_callback, workers, max_time):
        """
        execute_tests(progress_callback, workers, max_time)

        Execute the tests in the run using up to the specified number of
        parallel tasks, and inform the caller of each individual result. The
        provided tests should be a subset of the tests available in this run
        object.

        The progress_callback will be invoked for each completed test.

        If max_time is non-None, it should be a time in seconds after which to
        stop executing tests.

        Upon completion, each test in the run will have its result
        computed. Tests which were not actually executed (for any reason) will
        be given an UNRESOLVED result.
        """
        # Don't do anything if we aren't going to run any tests.
        if not self.tests:
            return

        self.progress_callback = progress_callback

        self.failure_count = 0
        self.hit_max_failures = False
        if workers == 1:
            self._execute_in_serial(max_time)
        else:
            self._execute_in_parallel(workers, max_time)

        # Mark any tests that weren't run as UNRESOLVED.
        for test in self.tests:
            if test.result is None:
                test.setResult(lit.Test.Result(lit.Test.UNRESOLVED, '', 0.0))

    def _execute_in_serial(self, max_time):
        for test_index, test in enumerate(self.tests):
            lit.worker._execute_test(test, self.lit_config)
            self._consume_test_result((test_index, test))
            if self.hit_max_failures:
                break

    def _execute_in_parallel(self, workers, max_time):
        assert workers > 1
        # We need to issue many wait calls, so compute the final deadline and
        # subtract time.time() from that as we go along.
        deadline = None
        if max_time:
            deadline = time.time() + max_time

        semaphores = {
            k: NopSemaphore() if v is None else
            multiprocessing.BoundedSemaphore(v) for k, v in
            self.lit_config.parallelism_groups.items()}

        # Start a process pool. Copy over the data shared between all test runs.
        # FIXME: Find a way to capture the worker process stderr. If the user
        # interrupts the workers before we make it into our task callback, they
        # will each raise a KeyboardInterrupt exception and print to stderr at
        # the same time.
        pool = multiprocessing.Pool(workers, lit.worker.initializer,
                                    (self.lit_config, semaphores))

        # Install a console-control signal handler on Windows.
        if lit.util.win32api is not None:
            def console_ctrl_handler(type):
                print('\nCtrl-C detected, terminating.')
                pool.terminate()
                pool.join()
                lit.util.abort_now()
                return True
            lit.util.win32api.SetConsoleCtrlHandler(console_ctrl_handler, True)

        try:
            async_results = [pool.apply_async(lit.worker.run_one_test,
                                              args=(test_index, test),
                                              callback=self._consume_test_result)
                             for test_index, test in enumerate(self.tests)]
            pool.close()

            # Wait for all results to come in. The callback that runs in the
            # parent process will update the display.
            for a in async_results:
                if deadline:
                    a.wait(deadline - time.time())
                else:
                    # Python condition variables cannot be interrupted unless
                    # they have a timeout. This can make lit unresponsive to
                    # KeyboardInterrupt, so do a busy wait with a timeout.
                    while not a.ready():
                        a.wait(1)
                if not a.successful():
                    a.get() # Exceptions raised here come from the worker.
                if self.hit_max_failures:
                    break
        except:
            # Stop the workers and wait for any straggling results to come in
            # if we exited without waiting on every async result.
            pool.terminate()
            raise
        finally:
            pool.join()

    def _consume_test_result(self, pool_result):
        """Test completion callback for lit.worker.run_one_test

        Updates the test result status in the parent process. Each task in the
        pool returns the test index and the result, and we use the index to look
        up the original test object. Also updates the progress bar as tasks
        complete.
        """
        # Don't add any more test results after we've hit the maximum failure
        # count.  Otherwise we're racing with the main thread, which is going
        # to terminate the process pool soon.
        if self.hit_max_failures:
            return

        (test_index, test_with_result) = pool_result
        # Update the parent process copy of the test. This includes the result,
        # XFAILS, REQUIRES, and UNSUPPORTED statuses.
        assert self.tests[test_index].file_path == test_with_result.file_path, \
                "parent and child disagree on test path"
        self.tests[test_index] = test_with_result
        self.progress_callback(test_with_result)

        # If we've finished all the tests or too many tests have failed, notify
        # the main thread that we've stopped testing.
        self.failure_count += (test_with_result.result.code == lit.Test.FAIL)
        if self.lit_config.maxFailures and \
                self.failure_count == self.lit_config.maxFailures:
            self.hit_max_failures = True
