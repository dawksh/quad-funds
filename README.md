# A contract to make disburse quadratic funds.

### What is quadratic funding?

By [Vitalik](https://vitalik.ca/general/2019/12/07/quadratic.html)

### Data Flow

Investor can add projects and lock in funds in the contract -> Block number can be specified to start public funding and stop the funding -> can't unlock the funds once the public funding starts -> a function can be used to disburse the funds to the respective projects

### Side Note

I tried to run this on the javascript chain on Remix IDE and it crashed. I am assuming the square root function is breaking it, or the values are overflowing somewhere.
