macro package loop

import std.ast.*
public import loop.exceptions.*

public macro Loop(input: Tokens): Tokens {
    checkBody(input)
    quote(loop{ res => 
        while(true) { $(input) } 
        throw UnreachableCodeException()
    }())
}

public macro Loop(label: Tokens, input: Tokens): Tokens {
    checkBody(input)
    let returningLambda = quote({ => 
        while(true) { $(input) } 
        throw UnreachableCodeException()
    }())
    if (let Some(labelVar) <- (parseDecl(quote(func fn($(label)))) as FuncParam)) {
        labelVar.dump()
        let labelLit = Token(STRING_LITERAL, labelVar.identifier.value)
        return quote({ => 
        let $(label)
        while (true) {
            try {
                $(returningLambda)
            } catch (breakLoop: BreakLoopException) {
                if ($(labelLit) == breakLoop.label) {
                    $(label)
                } else {
                    throw breakLoop
                }
            } catch (continueLoop: ContinueLoopException) {
                if ($(labelLit) == continueLoop.label) {
                    continue
                } else {
                    throw continueLoop
                }
            }
        }
        throw UnreachableCodeException()
    }())
    }
    input
}

public macro Break(input: Tokens): Tokens {
    assertParentContext("Loop")
    checkBreakExpr(input)
    quote(return $(input))
}

public macro Break(label: Tokens, input: Tokens): Tokens {
    assertParentContext("Loop")
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
    // checkLabel(label)
    quote(throw ContinueLoopException($(label)))
}

func checkBody(body: Tokens): Tokens {
    body
}

func checkBreakExpr(expr: Tokens): Tokens {
    expr
}
