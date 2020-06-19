{-# LANGUAGE ForeignFunctionInterface #-}
{-# LANGUAGE OverloadedStrings #-}

module Main where

import Data.Word (Word8)
import Foreign.ForeignPtr
import Foreign.Ptr
import qualified Data.Vector.Storable as S
import qualified Data.Vector.Storable.Mutable as SM
import qualified Codec.Picture as JP


testAmplitudes :: S.Vector Double
testAmplitudes = S.fromList



  [0,0,-10, 10, -10, 0, 0, -10, -10, 0, 10, 10, -10, -10, 0, -10, 10, 10,
   -10, 10, 10, 0, 10, -10, 0, 0, 0, 10, 10, 0, 10, -10, -10, -10, 10,
   -10, 10, 10, 10, 0, 0, -10, -10, 10, 10, -10, -10, 0, 0, 0, 10, -10,
   -10, -10, 0, -10, 0, -10, 10, -10, 0, 0, 0, -10, 10, 10, 0, 10, -10,
   10, 0, 10, -10, 10, -10, 0, 0, 0, -10, 0, 10, 10, 10, -10, 10, 10,
   10, 0, 10, -10, 0, 10, 10, 10, 10, 10, 0, 10, 0, -10, -10, 10, 0, 10,
   -10, -10, 10, 10, 10, 0, 0, -10, -10, -10, 0, 0, -10, -10, 10, 0, 10,
   0, 0, -10, -10, 10, 10, 10, -10, 10, 10, 10, -10, 0, 10, 0, -10, 10,
   10, 10, 10, 0, 0, 10, -10, -10, 10, -10, -10, 10, 0, 0, -10, 10, 0,
   -10, -10, -10, 10, -10, -10, 10, -10, 10, 0, -10, -10, 10, -10, -10,
   -10, 10, -10, -10, -10, -10, -10, -10, 10, 0, 10, -10, -10, 10, -10,
   0, 10, -10, 0, 10, 10, 0, -10, -10, 0, -10, -10, 0, 10, 10, 10, -10,
   10, -10, -10, -10, -10, 0, -10, -10, 10, 0, 0, -10, 10, -10, -10,
   -10, 10, 0, 0, 10, 10, 0, 10, -10, 10, -10, 10, 0, -10, -10, -10, -10,
   -10, 0, 0, 0, 10, -10, -10, 0, 10, -10, 10, -10, 0, 0, -10, 0, 10,
   -10, 0, 10, -10, -10, 10, 0, 10, 0, 0, -10, 10, -10, 10, 10, -10, 10,
   0, 10, -10, -10, -10, 10, 10, 0, -10, 0, 0, -10, -10, -10, -10, 0,
   -10, 0, 10, 0, 10, 0, -10, 10, 10, 0, 10, 0, -10, 10, 0, 10, -10, 0,
   10, -10, 0, 0, -10, -10, -10, -10, 0, 10, 0, -10, 10, -10, 10, 0, 0,
   10, 0, 10, 0, 10, 0, 0, 10, -10, 10, 10, 10, -10, 0, -10, -10, 10, 0,
   10, 0, 0, -10, 10, 10, -10, 10, 10, -10, 10, 10, 10, -10, -10, 10,
   10, 10, 10, -10, 0, 10, 10, 0, 0]


foreign import ccall "&freeTeaLeafQR" freeTeaLeafQRC :: FunPtr (Ptr Word8 -> IO ())
foreign import ccall "generateTeaLeafQR" generateTeaLeafQRC ::
  Ptr Double -> Int -> Int -> Int -> Int -> IO (Ptr Word8)



testImage :: IO (JP.Image Word8)
testImage = do
  SM.MVector length amplitudeForeignPtr <-  S.thaw testAmplitudes
  imagePtr <- withForeignPtr amplitudeForeignPtr
    (\p -> generateTeaLeafQRC p 420 420 10 10)
  imageForeignPtr <- newForeignPtr freeTeaLeafQRC imagePtr
  imageVector <- S.freeze $ S.MVector (420 * 420) imageForeignPtr
  return $ JP.Image 420 420 imageVector


main = do
  teaLeafImage <- testImage
  JP.writePng ("tealeaf.png") teaLeafImage
