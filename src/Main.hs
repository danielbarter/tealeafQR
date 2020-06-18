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
testAmplitudes = S.fromList [
   0.0,0.0,
   -3.50749, 4.11681,
   3.96204, 0.902212,
   1.76121, -2.298353,
   5, -3.03788,
   2.47675, -15.67449,
   -5.05481, -4.58991,
   0.280289, -3.51709,
   1.95524, 4.91539,
   0.0470628, -20.87474,
   3.54291, -0.981779,
   -0.247467, 0.443373,
   -1.16793, -4.83734]


foreign import ccall "&freeTeaLeafQR" freeTeaLeafQRC :: FunPtr (Ptr Word8 -> IO ())
foreign import ccall "generateTeaLeafQR" generateTeaLeafQRC ::
  Ptr Double -> Int -> Int -> Int -> Int -> IO (Ptr Word8)



testImage :: IO (JP.Image Word8)
testImage = do
  SM.MVector length amplitudeForeignPtr <-  S.thaw testAmplitudes
  imagePtr <- withForeignPtr amplitudeForeignPtr
    (\p -> generateTeaLeafQRC p 400 400 3 3)
  imageForeignPtr <- newForeignPtr freeTeaLeafQRC imagePtr
  imageVector <- S.freeze $ S.MVector (400 * 400) imageForeignPtr
  return $ JP.Image 400 400 imageVector


main = do
  teaLeafImage <- testImage
  JP.writePng ("tealeaf.png") teaLeafImage
