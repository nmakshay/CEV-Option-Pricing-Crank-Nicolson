# FINA_4140---Crank-Nicolson-Project
This repository contains the codes for a Matlab program that computes the price of an option (under the CEV model) using the Crank-Nicolson Method. The text of the project can be found in [https://drive.google.com/file/d/1MrrzNhgzVBeGGgMvX6Ief0ptcW4ZcF5Z/view]. This project is loosely based on the code in Higham (2004), which can be found in [http://personal.strath.ac.uk/d.j.higham/ch24.m]. The code by Higham (2004) only comptes the value of Put while my code computes both put and call using Crank Nicolson with an added option of using non-uniform discretization. 

The function of each file is mentioned below:

1. Crank_Nicolson_Pricing.m - This is the Matlab program that takes in input parameters and runs the 'priceoption' function to produce the the final prices. 
2. priceoption.m - This is the code of the pricing function. 
3. blsmesh.m - This is the same as the priceoption function, but uses the standard blsprice function (provided by Matlab) instead of my code, for benchmarking purposes. 
4. I have borrowed LBidiSol.m, UBidiSol.m and TriDiLU.m from Alfred Chan's CS370 Repo for tri-diagonal LU factorizations. 
5. The folders have the relevant codes to produce the figures in the project. 
