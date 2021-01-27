NB. Q&D Implementation of BLT Tool. More info: https://zenodo.org/record/4459271#.YBB7z9m2LR3 based on an SQL script by Wouter Aukema.

NB. USE: Change P and T and call calc with either equality or selband
load 'viewmat'
load'plot'
NB. -------------------------------------- Ranges


p=: 1000 % ~ 1 + 1 * i. 400
Sp=: 1000 % ~ 960 + i. (999-960)
Se=: 1000 % ~ 610 + i. (999-610)


NB. ---------------------------------------Samples

NB. T = total number of tests, P = positive tests


T=: 42000
P=: 3827

NB. -------------------------------------- Utils

hir2 =: 3 : ' */ > $ each y'



NB. -------------------------------------- Perms

size=: hir2 p;Sp;Se
perms=: (size $ p) , (size $ Se) ,: (size $ Sp)

NB. -------------------------------------- Bayes stuff


has_disease =: T * 0{perms
hasnot_disease =: T * (1 - 0{perms)

tp=: has_disease * 1{perms
tn=: hasnot_disease * 2{perms
fp=: hasnot_disease - tn
fn=: has_disease - tp


NB. -------------------------------------- Calculation

sets1=: (tp + (hasnot_disease - tn)) < (P+12)
sets2=:  (tp + (hasnot_disease - tn)) > (P-12)

equality=:   (tp + (hasnot_disease - tn)) = P

selband=: sets1 * sets2
simple=: (I. selband ) {"1 perms


NB. -------------------------------------- Table

calc=: monad define

('p';'Se';'Sp'), |:;/"1  (I. y ){"1 perms
)




NB. -------------------------------------- Graphs

pr=:0{simple
Sens=: 1{simple
Spec=: 2{simple
pindex=: /: pr
Seindex=: /: Sens
Spindex=: /: Spec


tbx=: 'Total tests: ', (": T) , '. Positive tests: ', (": P)
 
pd 'reset'
pd 'title Prevalence vs Specificity and Sensitivity'
pd 'key Sensitivity Specificity'
pd 'text 600 700 ', tbx
pd 'xcaption Prevalence'
pd 'ycaption Value'
pd 'keypos ble'
pd 'type dot'
pd 'pensize 0.2'
pd  (index{pr); (index{Sens),:(index{Spec)
pd 'show'



