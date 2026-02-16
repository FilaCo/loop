package loop.tests

import std.unittest.*
import std.unittest.testmacro.*
import loop.*
import loop.impl.*

@Test
class LoopTest {
    // @TestCase
    // func smoke() {
    //     // arrange
    //     var cnt = 0

    //     // act
    //     let actual = @Loop(
    //         cnt += 1
    //         if (cnt == 10) {
    //             @Break(cnt * 2)
    //         }
    //     )

    //     // assert
    //     @PowerAssert(20 == actual)
    // }

    // @TestCase
    // func breakOnlyInLoop() {
    //     // arrange
    //     // act
    //     let actual = @Break(10)
    //     // assert
    // }

    // @TestCase
    // func experiments() {
    //     let res = {
    //         => let outerLoopRes = {
    //             => let innerLoopRes = {
    //                 => while (true) {
    //                     return BreakLoop(0, 10)
    //                 }
    //             }()
    //         }()
    //     }()

    //     @Assert(10 == res)
    // }
}
