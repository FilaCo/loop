macro package loop

import std.ast.*

public macro Loop(attr: Tokens, input: Tokens): Tokens {
    input
}

public macro Loop(input: Tokens): Tokens {
    input
}

public macro Break(attr: Tokens, input: Tokens): Tokens {
    assertParentContext("Loop")
    input
}

public macro Break(input: Tokens): Tokens {
    assertParentContext("Loop")
    input
}

public macro Continue(input: Tokens): Tokens {
    assertParentContext("Loop")
    input
}
