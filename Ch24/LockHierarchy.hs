-- File: Real World Haskell/Ch24/LockHierarchy.hs
import Control.Concurrent
import NiceFork

nestedModification outer inner = do
  modifyMVar_ outer $ \x -> do
    yield  -- force this thread to temporarily yield the CPU
    modifyMVar_ inner $ \y -> return (y + 1)
    return (x + 1)
  putStrLn "done"

main = do
  a <- newMVar 1
  b <- newMVar 2
  manager <- newManager
  forkManaged manager $ nestedModification a b
  forkManaged manager $ nestedModification b a
  waitAll manager
