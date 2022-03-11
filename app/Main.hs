{- |
Copyright: (c) 2022 Iván Molina Rebolledo

SPDX-License-Identifier: GPL-3.0-only
Maintainer: Iván Molina Rebolledo <ivanmolinarebolledo@gmail.com>

See README for more info
-}
   
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE DeriveDataTypeable #-}
{-# OPTIONS_GHC -fno-cse #-}

module Main (main) where

import           VectorialSpaceModel (genVecs, search)
import qualified Data.ByteString as BS
import           Data.List
import qualified Data.Map as Dm
import           Data.Serialize

import           Data.Serialize.Text ()
import           Data.Text
import           Data.Text.IO as DT (readFile, putStrLn)
import System.Console.CmdArgs
import           Query (doQuery)
import Debug.Trace

type Save = ([String], [[Float]])

type Matrix = (Dm.Map Text (Dm.Map Int Double))

readTest :: FilePath -> IO Save
readTest name = do
  c <- DT.readFile name
  let r = genVecs (splitOn "\n" c)
  let word = sort 
        $ Data.List.delete " "
        $ Data.List.delete ""
        $ nub
        $ Data.List.map unpack 
        $ Data.List.concat
        $ Data.List.map (\o -> splitOn " " $ toLower o) 
        $ splitOn "\n" 
        $ replace "$ht" "" 
        $ replace "$user" "" 
        $ replace "$user tweeted" "" c
  return (word, r)

save :: Serialize a => a -> FilePath -> IO ()
save e name = do
  BS.writeFile name (encode e)

handleMatrix :: Text -> Text -> IO (Either String a)
handleMatrix input output = do
  matrix <- readTest (unpack input)
  save matrix (unpack output)
  return (Left "Done.")


load :: Serialize a => Text -> IO (Either String a)
load name = do
  bstr <- BS.readFile (unpack name)
  let m = decode bstr
  return m

stripLines ::  [Text] -> [(Int, Float)] -> [Text]
stripLines _ [] = []
stripLines [] _ = []
stripLines l (c:cc) = case Data.List.find (\(a,b) -> a==(fst c)) le of
  Just (n, t) -> pack ("[" ++ show n ++ "] " ++ (unpack t) ++ " (W: " ++ show (snd c) ++ ")") : stripLines l cc
  Nothing -> stripLines l cc
  where le = Data.List.zip [0..] l :: [(Int, Text)]

handleQuery :: Text -> Text -> String -> IO (Either String Text)
handleQuery query matrix_ defs = do
      val <- load matrix_
      case val of
        Right (aa,bb) -> do
          let l = search (unpack query) (aa) bb
          fs <- DT.readFile defs
          let ss = splitOn "\n" fs
          let yy = stripLines ss (Data.List.reverse $ sortOn snd (l))
          return $ Right (Data.Text.intercalate "\n" yy)
        Left err -> return $ Left (show err)


something :: VectorialSpaceModel -> IO (Either String Text)
something (Model from to) = handleMatrix (pack from) (pack to)
something (Query defs from q) = handleQuery (pack q) (pack from) defs


data VectorialSpaceModel = Model {from :: String, to :: String}
  | Query {ogfile :: String, model :: String, query :: String}
  deriving (Show, Data, Typeable)

genmatrix = Model {from = def, to = def}
doquery = Query {ogfile = def, model = def, query = def}


main :: IO ()
main = do
    args <- cmdArgs (modes [genmatrix,doquery])
    f <- something args
    case f of
      Right x -> DT.putStrLn x
      Left x -> Prelude.putStrLn x