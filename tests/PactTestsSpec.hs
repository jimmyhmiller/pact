module PactTestsSpec (spec) where


import Test.Hspec

import Pact.Repl
import Data.Either
import System.Directory
import System.FilePath
import Control.Monad

spec :: Spec
spec = do
  pactTests
  accountsTest


pactTests :: Spec
pactTests = describe "pact tests" $ do
  fs <- runIO findTests
  forM_ fs runScript

accountsTest :: Spec
accountsTest = describe "accounts regression" $ runScript ("examples" </> "accounts" </> "accounts.repl")


findTests :: IO [FilePath]
findTests = (map (tdir </>) . filter ((== ".repl") . reverse . take 5 . reverse)) <$> getDirectoryContents tdir
            where tdir = "tests" </> "pact"


runScript :: String -> SpecWith ()
runScript fp = it fp $ (fst <$> execScript' Interactive fp) >>= (`shouldSatisfy` isRight)
