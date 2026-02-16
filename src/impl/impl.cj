package loop.impl

public enum LoopAction<T> {
    BreakSelf(T) | ContinueSelf | BreakOuter(Int64, Box<Any>) | ContinueOuter(Int64)
}
