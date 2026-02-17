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
    checkBody(input)
    let returningLambda = quote({ => 
        while(true) { $(input) } 
        throw UnreachableCodeException()
    }())
    let tokLabelVar = quote(var $(label))
    if (let Some(labelVar) <- (parseDecl(tokLabelVar) as VarDecl)) {
        let labelIdent = labelVar.identifier
        let labelIdentLit = Token(STRING_LITERAL, labelIdent.value)
        return quote({ => 
        $(tokLabelVar) = unsafe { zeroValue() }
        while (true) {
            try {
                $(returningLambda)
            } catch (breakLoop: BreakLoopException) {
                if ($(labelIdentLit) == breakLoop.label) {
                    return $(labelIdent)
                } else {
                    throw breakLoop
                }
            } catch (continueLoop: ContinueLoopException) {
                if ($(labelIdentLit) == continueLoop.label) {
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
    let labelLit = Token(STRING_LITERAL, label.toString()).toTokens()
    quote(
        $(label) = $(input)
        throw BreakLoopException($(labelLit))
    )
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
