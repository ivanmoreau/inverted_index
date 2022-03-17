\section{Índice invertido}

Esta sección es Literate Haskell. El mismo código es parte del ejecutable y 
parte del documento.

Licencia:
\begin{code}
{- |
Copyright: (c) 2022 Iván Molina Rebolledo

SPDX-License-Identifier: GPL-3.0-only
Maintainer: Iván Molina Rebolledo <ivanmolinarebolledo@gmail.com>

See README for more info
-}
\end{code}

Boilerplate:
\begin{code}
{-# LANGUAGE OverloadedStrings #-}

module InvertedIndex (  genVecs, search ) where

import           TFIDFV (weightTFIDF, weightTFIDF_Query)
import Data.Text (replace, Text, unpack)
import Data.List (transpose)
import Debug.Trace
\end{code}

Producto punto:
\begin{code}
-- dot :: Num a => [a] -> [a] -> a
-- dot x y = sum $ zipWith (*) x y
dot :: InvertedI -> Int -> [Float] -> Float
dot x i y = f x y where
  f [] [] = 0
  f (x:xs) (y:ys) = f xs ys + case lookup i x of
    Nothing -> 0.0
    Just k -> k * y
\end{code}

Usando el coseno, la similaridad entre el documento d$_j$ y la
consulta q, puede ser calculado como:
\begin{code}
cos_ :: InvertedI -> Int -> [Float] -> Float
cos_ dⱼ i q = (dot dⱼ i q)/(p (map k dⱼ) * p q)
  where p a = sqrt $ sum $ map (\x -> x*x) a
        k o = case lookup i o of
          Nothing -> 0.0
          Just y -> y
\end{code}

Definimos los tipos para el índice invertido.
\begin{code}
type Weigth = Float
type Document = Int
type InvertedI = [[(Document, Weigth)]]
\end{code}

Realizamos una consulta comparandola con todos los documentos:
\begin{code}
search :: String --Query
  -> [String] -- Sorted words
  -> InvertedI -- Indexes
  -> Int -- N docs
  -> [(Int, Float)] -- Matches
search q l f ii = let
  qq = weightTFIDF_Query l ii q
  qq2 = filter (\u -> (>0.0) $ snd u) $ zip [0..] (trace (show qq) qq) :: [(Int, Float)] -- Word, Weigth
  nl = map (f !!) $ map fst qq2
  oo = map (\p -> cos_ nl p (map snd qq2)) [0..(ii - 1)]
  ot = zip [0..] oo in
  filter (\(_,n) -> n>0.0) ot
\end{code}
Es probable que la implementación dada en este caso sea inferior
a la de usar vectores directamente. Especialemente porque hay
más funciones a tratar en esta implementación.

En el módulo TFIDFV tambien se hace uso de una índice invertido.
Esa parte ha quedado intacta desde la última practica.

Generemos la representasión en índice invertido de los documentos:
\begin{code}
genVecs :: [Text] -> InvertedI
genVecs a = let v = weightTFIDF $ map unpack (map (\d -> replace "$ht" "" (replace "tweeted:" "" (replace "$user" "" d))) a) in
  (trace (show $ f v) f (trace (show v) v)) where
  f [] = []
  f xs = map nn $ transpose xs
  nn x = let h = zip [0..] $ x :: [(Int, Float)]
             k = filter (\u -> (snd u)>0.0) h in
             k
\end{code}