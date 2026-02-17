package loop.tests

import std.unittest.*
import std.unittest.testmacro.*
import loop.*

@Test
class LoopTest {
    @TestCase
    func simple() {
        // arrange
        var cnt = 0

        // act
        @Loop(
            cnt += 1
            if (cnt >= 10) {
                @Break()
            }
        )

        // assert
        @PowerAssert(10 == cnt)
    }

    @TestCase
    func returningValue() {
        // arrange
        var cnt = 0

        // act
        let actual = @Loop(
            cnt += 1
            if (cnt >= 10) {
                @Break(cnt * 2)
            }
        )

        // assert
        @PowerAssert(20 == actual)
    }

    // @TestCase
    // func returningValueFromInner() {
    //     // arrange
    //     var cnt = 0

    //     // act
    //     let actual = @Loop[countingUp](
    //         var remaining = 10

    //         @Loop(
    //             if (remaining == 9) {
    //                 @Break()
    //             }
    //             if (cnt == 2) {
    //                 @Break[countingUp](cnt * 10)
    //             }
    //             remaining -= 1
    //         )

    //         cnt += 1
    //     )

    //     // assert
    //     @PowerAssert(20 == actual)
    // }

    @TestCase
    func experiments() {
        var cnt = 0
        let actual = {
            =>
                var countingUp = unsafe { zeroValue<Int64>() } // how to do that?
                while (true) {
                    try {
                        {
                            =>
                                while (true) {
                                    var remaining = 10
                                    {
                                        =>
                                            while (true) {
                                                if (remaining == 9) {
                                                    return
                                                }
                                                if (cnt == 2) {
                                                    {
                                                        =>
                                                            countingUp = cnt * 10
                                                            throw BreakLoopException("countingUp")
                                                    }()
                                                }
                                                remaining -= 1
                                            }
                                            throw UnreachableCodeException()
                                    }()
                                    cnt += 1
                                }
                                throw UnreachableCodeException()
                        }()
                    } catch (breakLoop: BreakLoopException) {
                        if ("countingUp" == breakLoop.label) {
                            return countingUp
                        } else {
                            throw breakLoop
                        }
                    } catch (continueLoop: ContinueLoopException) {
                        if ("countingUp" == continueLoop.label) {
                            continue
                        } else {
                            throw continueLoop
                        }
                    }
                }
                throw UnreachableCodeException()
        }()

        @PowerAssert(20 == actual)
    }
}
