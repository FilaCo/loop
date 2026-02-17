macro package loop

import std.ast.*
public import loop.exceptions.*

public macro Loop(input: Tokens): Tokens {
    checkBody(input)
    quote({ => 
        while(true) { $(input) } 
        throw UnreachableCodeException()
    }())
}

public macro Loop(label: Tokens, input: Tokens): Tokens {
    checkLabel(label)
    checkBody(input)
    let returningLambda = quote({ => 
        while(true) { $(input) } 
        throw UnreachableCodeException()
    }())
    let labelLiteral = Token(STRING_LITERAL, label.toString()).toTokens()
    quote({ => 
        var $(label) = unsafe { zeroValue() }
        while (true) {
            try {
                $(returningLambda)
            } catch (breakLoop: BreakLoopException) {
                if ($(labelLiteral) == breakLoop.label) {
                    $(label)
                } else {
                    throw breakLoop
                }
            } catch (continueLoop: ContinueLoopException) {
                if ($(labelLiteral) == continueLoop.label) {
                    continue
                } else {
                    throw continueLoop
                }
            }
        }
        throw UnreachableCodeException()
    }())
}

public macro Break(input: Tokens): Tokens {
    assertParentContext("Loop")
    checkBreakExpr(input)
    quote(return $(input))
}

public macro Break(label: Tokens, input: Tokens): Tokens {
    assertParentContext("Loop")
    checkLabel(label)
    checkBreakExpr(input)
    let labelLiteral = Token(STRING_LITERAL, label.toString()).toTokens()
    quote({ => 
        $(label) = $(input)
        throw BreakLoopException($(labelLiteral))
    }())
}

public macro Continue(label: Tokens): Tokens {
    assertParentContext("Loop")
    if (label.size == 0) {
        return quote(continue)
    }
    checkLabel(label)
    quote(throw ContinueLoopException($(label)))
}

func checkLabel(label: Tokens): Tokens {
    label
}

func checkBody(body: Tokens): Tokens {
    body
}

func checkBreakExpr(expr: Tokens): Tokens {
    expr
}
