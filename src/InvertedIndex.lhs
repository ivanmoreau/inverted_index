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
import Data.List (transpose, (\\), sortOn)
import Debug.Trace
\end{code}

Producto punto:
\begin{code}
dot :: Num a => [a] -> [a] -> a
dot x y = sum $ zipWith (*) x y
\end{code}

Usando el coseno, la similaridad entre el documento d$_j$ y la
consulta q, puede ser calculado como:
\begin{code}
cos_ :: [Float] -> [Float] -> Float
cos_ dⱼ q = (dot dⱼ q)/(p dⱼ * p q)
  where p a = sqrt $ sum $ map (\x -> x*x) a
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
  oo = map (\p -> cos_ qq p) (kl f) 
  ot = zip [0..] oo in
  filter (\(_,n) -> n>0.0) ot where
  kl p = transpose $ map kj p
  kj p = let ff = map fst p 
             nff = map (\z -> (z,0.0)) $ [0..ii - 1] \\ ff in
             map snd $ sortOn fst $ p ++ nff
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