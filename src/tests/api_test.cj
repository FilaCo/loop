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

    @TestCase
    func returningValueFromInner() {
        // arrange
        var cnt = 0

        // act
        let actual = @Loop[countingUp: Int64](
            var remaining = 10

            @Loop(
                if (remaining == 9) {
                    @Break()
                }
                if (cnt == 2) {
                    @Break[countingUp](cnt * 10)
                }
                remaining -= 1
            )

            cnt += 1
        )

        // assert
        @PowerAssert(20 == actual)
    }

}

