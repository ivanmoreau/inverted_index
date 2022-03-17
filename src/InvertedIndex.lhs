\section{Modelo de Espacio Vectorial}

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

es decir, $\mathrm{cos}(d_j,q) = \frac{\mathbf{d_j} \cdot \mathbf{q}}{\left\| \mathbf{d_j} \right\| \left \| \mathbf{q} \right\|} = \frac{\sum _{i=1}^N w_{i,j}w_{i,q}}{\sqrt{\sum _{i=1}^N w_{i,j}^2}\sqrt{\sum _{i=1}^N w_{i,q}^2}}$.

Realizamos una consulta comparandola con todos los docuementos:
\begin{code}
search :: String --Query
  -> [String] -- Sorted words
  -> [[Float]] -- Vectors
  -> [(Int, Float)] -- Matches
search q l f = let
  qq = weightTFIDF_Query l (length f) q 
  oo = map (\p -> cos_ qq p) f 
  ot = zip [0..] oo in
  filter (\(_,n) -> n>0.0) ot
\end{code}

Generemos los vectores de los documentos:
\begin{code}
genVecs :: [Text] -> [[Float]]
genVecs a = weightTFIDF $ map unpack (map (\d -> replace "$ht" "" (replace "tweeted:" "" (replace "$user" "" d))) a)
\end{code}