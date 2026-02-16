macro package loop

import std.ast.*

public macro Loop(input: Tokens): Tokens {
    quote(while(true) { $(input) })
}

public macro Break(_: Tokens): Tokens {
    assertParentContext("Loop")
    quote(break)
}
