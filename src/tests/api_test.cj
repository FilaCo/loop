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
}
