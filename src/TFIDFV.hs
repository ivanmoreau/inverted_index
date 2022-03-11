{-# LANGUAGE OverloadedStrings  #-}

module TFIDFV (weightTFIDF, weightTFIDF_Query) where

import qualified Data.Map as DM
import Data.List (group, insert, sortOn, delete)
import Data.Char (toLower)
import Data.Map (Map)
import Data.Text (pack, split, unpack)
import Data.Universe.Helpers ((+*+))
import Debug.Trace

line_count :: String -> [(String, Int)]
line_count str = map (\x -> (unpack $ head x, length x))
  $ group 
  $ filter (/="") 
  $ split (==' ') (pack str)

ints :: (String, (Int, Int)) 
  -> [(String, [(Int, Int)])] 
  -> [(String, [(Int, Int)])]
ints (s, (d, n)) r = case lookup s r of
  Nothing -> insert (s, [(d, n)]) r
  Just o -> let p = sortOn fst $ (d,n):o in
    insert (s, p) $ delete (s, o) r

addas :: [[(String, Int)]] -> Int -> [(String, [(Int, Int)])]
addas [] _ = []
addas (x:xs) c = foldl (\l (str,v) -> f str v c l) (addas xs (c + 1)) x where
  f s n d r = ints (s, (d, n)) r

lista_inv :: [String] -> [(String, [(Int, Int)])]
lista_inv s = sortOn (\x -> (map toLower) $ fst x)
  $ addas (map line_count s) 1

type Doc = Map Int [(Int, Float)]

inssm :: [((Int, Int), Float)] -> Doc
inssm [] = DM.fromList []
inssm (((a,b),c):xs) = let r = inssm xs in
  case DM.lookup a r of
    Nothing -> DM.insert a [(b,c)] r
    Just x -> DM.insert a (sortOn fst ((b,c):x)) r

weightTFIDF :: 
  [String] -- Docs
  -> [[Float]] -- Vector
weightTFIDF str =
  let p = ([1..length (trace (show $ fst $ unzip linv) linv)] +*+ [1..length str])
      r = map (\x -> (x, uncurry w x)) p
      -- rr = DM.toList $ inssm r
      ar = sortOn (\x -> snd $ fst x) r in
      map (map snd) 
        $ map (\x -> filter (\((_,r_),_) -> r_ == x) ar) 
          [1..length str] where 
  linv = lista_inv str
  _N = fromIntegral $ length str
  f i j = case lookup j (snd $ linv !! (i - 1)) of
    Nothing -> 0.0 :: Float
    Just x -> fromIntegral x 
  w i j = if f i j > 0 then
    (1.0 + (logBase 2.0 (f i j))) * (logBase 2.0 (_N / n i))
  else 
    0.0 where
    n i_ = f i_ j


zz :: [(String, [(Int, Int)])] -> [(String, [(Int, Int)])]
zz = map (\(s, _) -> (s, []))

zz2 :: [String] -> [(String, [(Int, Int)])]
zz2 = map (\s -> (s, []))

zn :: [(String, [(Int, Int)])] -> [(String, [(Int, Int)])] -> [(String, [(Int, Int)])]
zn _ [] = []
zn [] o = o
zn ((sf, r):a) ((sd, r2):ns)
  | sf == sd = (sf, r):zn a ns
  | otherwise = (sd, r2):zn ((sf, r):a) ns

weightTFIDF_Query :: 
  [String] -- Sorted words
  -> Int -- Number of docs 
  -> String -- Query 
  -> [Float] -- Vector
weightTFIDF_Query linv __N query =
  let p = ([1..length linv] +*+ [1])
      r = map (\x -> (x, uncurry w x)) p
      -- rr = DM.toList $ inssm r
      ar = sortOn (\x -> snd $ fst x) r in
      head $ map (map snd) 
        $ map (\x -> filter (\((_,r_),_) -> r_ == x) ar) 
          [1] where 
  qq = lista_inv [query]
  linnvf = (zn qq (zz2 linv)) 
  _N = fromIntegral __N
  f i j = case lookup j (snd $ linnvf !! (i - 1)) of
    Nothing -> 0.0 :: Float
    Just x -> fromIntegral x 
  w i j = if f i j > 0 then
    (1.0 + (logBase 2.0 (f i j))) * (logBase 2.0 (_N / n i))
  else 
    0.0 where
    n i_ = f i_ j