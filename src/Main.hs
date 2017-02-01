{-# LANGUAGE OverloadedStrings   #-}
{-# LANGUAGE ScopedTypeVariables #-}

import           Control.Lens           ((&), (.~), (<&>), (?~))
import           Data.Text              (Text)
import           Network.Google
import           Network.Google.Storage
import           System.IO              (stdout)

import qualified Data.Text              as Text

main
  :: IO ()
main = do
    lgr  <- newLogger Trace stdout
    env  <- newEnv <&> (envLogger .~ lgr) . (envScopes .~ storageReadWriteScope)
    body <- sourceBody "/some/photo.jpg"

    let key = "image.jpg"
        bkt = "my-storage-bucket"

    runResourceT . runGoogle env $
        upload (objectsInsert bkt object' & oiName ?~ key) body

    return ()
