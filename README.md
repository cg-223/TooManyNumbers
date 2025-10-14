# Unfinished

TMN doenst currently work as Talisman does.

# Too Many Numbers
This mod succeeds *Talisman* as the goto mod for numbers above 1e308.

Too Many Numbers (TMN) uses Omeganum (from Naruyoko, ported by Mathguy23) to increase the score limit, feasibly to 10{1000}10.

TMN relies on Steamodded, and is not a lovely mod.

The main difference between TMN and Talisman is that TMN eliminates many mod incompatibility issues.

Mod developers should not need to add any support for TMN, as it will likely Just Work.

# Concerns
Talisman has many issues with "poisoning". This is caused by the fact that, when big numbers are used in operations, the results will be big numbers. Thus, safeguards have to be placed in many places to ensure that things like UI sizes aren't poisoned.

Too Many Numbers is being designed from the start to mitigate these problems through further means (ideally not needing the repetitive safeguards Talisman has, as they typically also require mods to add their own guards)



# Todos

## Omeganum core

The core (number holding/operating mechanisms) of Too Many Numbers is heavily copied from Talisman. However, heavy modification is necessary. 

## Balatro integration
Mult, chips, score, dollars, and more all need to be non-leaking bignumbers. This needs to be done after the core is completed.
