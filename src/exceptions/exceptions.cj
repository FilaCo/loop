package loop.exceptions

public class BreakLoopException <: Exception {
    public BreakLoopException(public let label: String) {}
}

public class ContinueLoopException <: Exception {
    public ContinueLoopException(public let label: String) {}
}

public class UnreachableCodeException <: Exception {
    public UnreachableCodeException() {}
}
