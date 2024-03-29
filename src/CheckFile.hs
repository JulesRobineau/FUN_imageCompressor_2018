-- @Author: rjules
-- @Date:   2019-04-26 05:17:15
-- @Last Modified by:   rjules
-- @Last Modified time: 2019-04-28 18:30:55

module CheckFile (
    Point(..),
    Color(..),
    Pixel(..),
    Centroid(..),
    Cluster(..),
    Obj(..),
    checkFile
) where

import CheckArgs
import Split

data Cluster = Cluster {
    centroid :: Centroid,
    pixels :: [Pixel]
} deriving (Eq, Show)

data Point = Point {
    x :: Int,
    y :: Int
} deriving (Eq, Show)

data Color = Color {
    colorR :: Int,
    colorG :: Int,
    colorB :: Int
} deriving (Eq, Show)

data Centroid = Centroid {
    centrR :: Float,
    centrG :: Float,
    centrB :: Float
} deriving (Eq, Show)

data Pixel = Pixel {
    point :: Point,
    color :: Color
} deriving (Eq, Show)

data Obj = Obj {
    n :: Int,
    e :: Float,
    pixel :: [Pixel]
} deriving (Show)

checkColor :: String -> Color
checkColor color
    | head color /= '(' || last color /= ')' = error "Invalid color writting"
    | isInteger (tail (strC !! 0)) == False || colorR < 0 || colorR > 255 = error "Invalid Red color"
    | isInteger (strC !! 1) == False || colorG < 0 || colorG > 255 = error "Invalid Green color"
    | isInteger (init (strC !! 2)) == False || colorB < 0 || colorB > 255 = error "Invalid Blue color"
    | otherwise = Color colorR colorG colorB
    where
        strC = split color ','
        colorR = read (tail (strC !! 0)) :: Int
        colorG = read (strC !! 1) :: Int
        colorB = read (init (strC !! 2)) :: Int

checkPoint :: String -> Point
checkPoint point
    | head point /= '(' || last point /= ')' = error "Invalid point writting"
    | isInteger (tail (strP !! 0)) == False || x < 0 = error "Invalid x point"
    | isInteger (init (strP !! 1)) == False || y < 0 = error "Invalid y point"
    | otherwise = Point x y
    where
        strP = split point ','
        x = read (tail (strP !! 0)) :: Int
        y = read (init (strP !! 1)) :: Int

convert :: String -> Pixel
convert line
    | length pixel /= 2 = error "Invalid pixel"
    | length point /= 2 = error "Invalid Point"
    | length color /= 3 = error "Invalid Color"
    | otherwise = Pixel (checkPoint (pixel !! 0)) (checkColor (pixel !! 1))
    where
        pixel = split line ' '
        point = split (pixel !! 0) ','
        color = split (pixel !! 1) ','

checkFile :: String -> IO [Pixel]
checkFile str = do
    content <- readFile str
    let tab_line = lines content
    return $ map convert tab_line