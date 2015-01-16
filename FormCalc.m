(*

This is FormCalc, Version 5.4
Copyright by Thomas Hahn 1996-2008
last modified 29 May 08 by Thomas Hahn

Release notes:

FormCalc is free software, but is not in the public domain.
Instead it is covered by the GNU library general public license.
In plain English this means:

1. We don't promise that this software works.
   (But if you find any bugs, please let us know!)

2. You can use this software for whatever you want.
   You don't have to pay us.

3. You may not pretend that you wrote this software.
   If you use it in a program, you must acknowledge
   somewhere in your publication that you've used
   our code.

If you're a lawyer, you can find the legal stuff at
http://www.fsf.org/copyleft/lgpl.html.

The user guide for this program can be found at
http://www.feynarts.de/formcalc.

If you find any bugs, or want to make suggestions, or
just write fan mail, address it to:
	Thomas Hahn
	Max-Planck-Institute for Physics
	Foehringer Ring 6
	D-80805 Munich, Germany
	e-mail: hahn@feynarts.de

There exists a low-traffic mailing list where updates will be
announced.  Contact hahn@feynarts.de to be added to this list.

Have fun!

*)

Print[""];
Print["FormCalc 5.4"];
Print["by Thomas Hahn"];
Print["last revised 29 May 08"]


If[ $VersionNumber < 6,
  Needs["Algebra`Horner`"];

  (* actually load the Horner package so that the Off works: *)
  Algebra`Horner[1];
  Off[Algebra`Horner::fail];

  System`HornerForm = Algebra`Horner`Horner
]


(* symbols from FeynArts *)

BeginPackage["FeynArts`"]

{ FeynAmp, FeynAmpList, Process, GraphID, Number,
  Generic, Classes, Particles, S, F, U, V, T,
  Insertions, G, Mass, GaugeXi, VertexFunction,
  PropagatorDenominator, FeynAmpDenominator,
  FourMomentum, Internal, External, TheMass,
  Index, IndexDelta, IndexEps, IndexSum, SumOver,
  MatrixTrace, FermionChain, NonCommutative,
  CreateTopologies, ExcludeTopologies, Tadpoles,
  Paint, InsertFields, CreateFeynAmp, Truncated, RenConst,
  ProcessName, DiagramGrouping }

EndPackage[]


(* symbols from LoopTools *)

BeginPackage["LoopTools`"]

A0i (* need this internally *)

A0::usage =
"A0[m] is the one-point one-loop scalar integral.  m is the mass
squared."

A00::usage =
"A00[m] is the one-point tensor coefficient of g_{mu nu}.  m is the mass
squared."

B0i::usage =
"B0i[id, p, m1, m2] is the generic two-point one-loop integral which
includes scalar and tensor coefficients as well as their derivatives
with respect to p, specified by id.  For example, B0i[bb0, ...] is the
scalar function B_0, B0i[bb11, ...] the tensor coefficient function
B_{11} etc.  p is the external momentum squared and m1 and m2 are the
masses squared."

{ bb0, bb1, bb00, bb11, bb001, bb111, dbb0, dbb1, dbb00, dbb11,
  cc0, cc00, cc001, cc002, cc0000, cc0011, cc0022, cc0012,
  dd0, dd0000, dd00001, dd00002, dd00003, ee0, ff0 }

C0i::usage =
"C0i[id, p1, p2, p1p2, m1, m2, m3] is the generic three-point one-loop
integral which includes both scalar and tensor coefficients, specified
by id.  For example, C0i[cc0, ...] is the scalar function C_0,
C0i[cc112, ...] the tensor coefficient function C_{112} etc.  p1, p2,
and p1p2 are the external momenta squared and m1, m2, m3 are the masses
squared."

D0i::usage =
"D0i[id, p1, p2, p3, p4, p1p2, p2p3, m1, m2, m3, m4] is the generic
four-point one-loop integral which includes both scalar and tensor
coefficients, specified by id.  For example, D0i[dd0, ...] is the scalar
function D_0, D0i[dd1233, ...] the tensor function D_{1233} etc. 
p1...p4 are the external momenta squared, p1p2 and p2p3 are the squares
of external momenta (1+2) and (2+3), respectively, and m1...m4 are the
masses squared."

E0i::usage =
"E0i[id, p1, p2, p3, p4, p5, p1p2, p2p3, p3p4, p4p5, p5p1, m1, m2, m3,
m4, m5] is the generic five-point one-loop integral which includes both
scalar and tensor coefficients, specified by id.  For example,
E0i[ee0, ...] is the scalar function E_0, E0i[ee1244, ...] the tensor 
function E_{1244} etc.  p1...p5 are the external momenta squared, 
p1p2...p5p1 are the squares of external momenta (1+2)...(5+1), 
respectively, and m1...m5 are the masses squared."

F0i::usage =
"F0i[id, p1, p2, p3, p4, p5, p6, p1p2, p2p3, p3p4, p4p5, p5p6, p6p1,
p1p2p3, p2p3p4, p3p4p5, m1, m2, m3, m4, m5, m6] is the generic six-point
one-loop integral which includes both scalar and tensor coefficients,
specified by id.  For example, F0i[ff0, ...] is the scalar function F_0,
F0i[ff1244, ...] the tensor function F_{1244} etc.  p1...p6 are the
external momenta squared, p1p2...p6p1 are the squares of external
momenta (1+2)...(6+1), respectively, p1p2p3...p3p4p5 are the external
momenta (1+2+3)...(3+4+5) squared, and m1...m6 are the masses squared."


(* compatibility functions *)

B0::usage =
"B0[p, m1, m2] is the two-point one-loop scalar integral."

B1::usage =
"B1[p, m1, m2] is the coefficient of k_mu in the two-point one-loop
tensor integral B_mu."

B00::usage =
"B00[p, m1, m2] is the coefficient of g_{mu nu} in the two-point
one-loop tensor integral B_{mu nu}."

B11::usage =
"B11[p, m1, m2] is the coefficient of k_mu k_nu in the two-point
one-loop tensor integral B_{mu nu}."

B001::usage =
"B001[p, m1, m2] is the coefficient of g_{mu nu} k_rho in the two-point
one-loop tensor integral B_{mu nu rho}."

B111::usage =
"B111[p, m1, m2] is the coefficient of k_mu k_nu k_rho in the two-point
one-loop tensor integral B_{mu nu rho}."

DB0::usage =
"DB0[p, m1, m2] is the derivative of B0[p, m1, m2] with respect to p."

DB1::usage =
"DB1[p, m1, m2] is the derivative of B1[p, m1, m2] with respect to p."

DB00::usage =
"DB00[p, m1, m2] is the derivative of B00[p, m1, m2] with respect to p."

DB11::usage =
"DB11[p, m1, m2] is the derivative of B11[p, m1, m2] with respect to p."

C0::usage =
"C0[p1, p2, p1p2, m1, m2, m3] is the three-point scalar one-loop
integral."

D0::usage =
"D0[p1, p2, p3, p4, p1p2, p2p3, m1, m2, m3, m4] is the four-point scalar
one-loop integral."

E0::usage =
"E0[p1, p2, p3, p4, p5, p1p2, p2p3, p3p4, p4p5, p5p1, m1, m2, m3, m4,
m5] is the five-point scalar one-loop integral."

F0::usage =
"F0[p1, p2, p3, p4, p5, p6, p1p2, p2p3, p3p4, p4p5, p5p6, p6p1, p1p2p3,
p2p3p4, p3p4p5, m1, m2, m3, m4, m5, m6] is the six-point scalar one-loop
integral."

PaVe::usage =
"PaVe[ind, {pi}, {mi}] is the generalized Passarino-Veltman function
used by FeynCalc.  It is converted to B0i, C0i, D0i, E0i, or F0i in
FormCalc."

ToOldBRules::usage =
"ToOldBRules is a list of rules for converting two-point functions to
the old (LoopTools 2.1) conventions."

ToNewBRules::usage =
"ToNewBRules is a list of rules for converting two-point functions to
the new (LoopTools 2.2) conventions."

EndPackage[]


(* symbols from CutTools *)

BeginPackage["CutTools`"]

Acut::usage =
"Acut[num, m] is the one-point integral with numerator function num.  m
is the mass squared."

Bcut::usage =
"Bcut[num, p, m1, m2] is the two-point one-loop integral with numerator
function num.  p is the external momentum squared and m1 and m2 are the
masses squared."

Ccut::usage =
"Ccut[num, p1, p2, p1p2, m1, m2, m3] is the three-point one-loop
integral with numerator function num.  p1, p2, and p1p2 are the external
momenta squared and m1, m2, m3 are the masses squared."

Dcut::usage =
"Dcut[num, p1, p2, p3, p4, p1p2, p2p3, m1, m2, m3, m4] is the four-point
one-loop integral with numerator function num.  p1...p4 are the external
momenta squared, p1p2 and p2p3 are the squares of external momenta (1+2)
and (2+3), respectively, and m1...m4 are the masses squared."

Ecut::usage =
"Ecut[num, p1, p2, p3, p4, p5, p1p2, p2p3, p3p4, p4p5, p5p1, m1, m2, m3,
m4, m5] is the five-point one-loop integral with numerator function num. 
p1...p5 are the external momenta squared, p1p2...p5p1 are the squares of
external momenta (1+2)...(5+1), respectively, and m1...m5 are the masses
squared."

Fcut::usage =
"Fcut[num, p1, p2, p3, p4, p5, p6, p1p2, p2p3, p3p4, p4p5, p5p6, p6p1,
p1p2p3, p2p3p4, p3p4p5, m1, m2, m3, m4, m5, m6] is the six-point
one-loop integral with numerator function num.  p1...p6 are the external
momenta squared, p1p2...p6p1 are the squares of external momenta
(1+2)...(6+1), respectively, p1p2p3...p3p4p5 are the external momenta
(1+2+3)...(3+4+5) squared, and m1...m6 are the masses squared."

EndPackage[]


BeginPackage["Form`"]

{ abb, fme, sun, pave, cuti, dJ, eJ, iJ, dummyJ, q1, pow, SUNSum }

EndPackage[]


(* symbols from the model files live in Global` *)

{ DiracMatrix, DiracSlash, ChiralityProjector,
  DiracSpinor, MajoranaSpinor,
  PolarizationVector, PolarizationTensor,
  MetricTensor, LeviCivita, FourVector, ScalarProduct,
  Lorentz, EpsilonScalar,
  SUNT, SUNF, SUNTSum, SUNEps, Colour, Gluon }

SelfEnergy::usage =
"SelfEnergy[from -> to, mass] calculates the self-energy with incoming
particle from and outgoing particle to, taken at k^2 = mass^2. 
SelfEnergy[f] calculates the self-energy of particle f on its mass
shell."

DSelfEnergy::usage =
"DSelfEnergy[from -> to, mass] calculates the derivative with respect to
k^2 of the self-energy with incoming particle from and outgoing particle
to, taken at k^2 = mass^2.  DSelfEnergy[f] calculates the self-energy of
particle f on its mass shell."

ReTilde::usage =
"ReTilde[expr] takes the real part of loop integrals occurring in expr."

ImTilde::usage =
"ImTilde[expr] takes the imaginary part of loop integrals occurring in
expr."

LVectorCoeff::usage =
"LVectorCoeff[expr] returns the coefficient of DiracChain[6, k[1]]
(= k1slash omega_-) in expr."

RVectorCoeff::usage =
"RVectorCoeff[expr] returns the coefficient of DiracChain[7, k[1]]
(= k1slash omega_+) in expr."

LScalarCoeff::usage =
"LScalarCoeff[expr] returns the coefficient of DiracChain[7] (= omega_-)
in expr."

RScalarCoeff::usage =
"RScalarCoeff[expr] returns the coefficient of DiracChain[6] (= omega_+)
in expr."

SEPart::usage =
"SEPart[p, se] returns part p of self-energy se.  It is applied during
the calculation of a renormalization constant, where p is one of
LVectorCoeff, RVectorCoeff, LScalarCoeff, RScalarCoeff for fermion
self-energies, and Identity otherwise."

MassRC::usage =
"MassRC[f] computes the one-loop mass renormalization constant of field
f.  MassRC[f1, f2] computes the one-loop mass renormalization constant
for the f1-f2 transition.  For fermions the output is a list
{left-handed RC, right-handed RC}."

FieldRC::usage =
"FieldRC[f] computes the one-loop field renormalization constant of
field f.  FieldRC[f1, f2] computes the one-loop field renormalization
constant for the f1-f2 transition.  For fermions the output is a list
{left-handed RC, right-handed RC}."

TadpoleRC::usage =
"TadpoleRC[f] computes the one-loop tadpole renormalization constant of
field f."

WidthRC::usage =
"WidthRC[f] computes the one-loop width of field f."


BeginPackage["FormCalc`",
  {"FeynArts`", "LoopTools`", "CutTools`", "Form`", "Global`",
   "Utilities`FilterOptions`"}]

(* some internal symbols must be visible for ReadForm *)

{ ReadForm, ClearCache, FormSetup }

(* some internal symbols made visible for debugging *)

{ InvSum, PairRules }


(* symbols appearing in the output *)

Amp::usage =
"Amp[proc][expr1, expr2, ...] is the result of the calculation of
diagrams of the process proc.  The result is divided into parts expr1,
expr2, ..., such that index sums (marked by SumOver) apply to the whole
of each part."

Den::usage =
"Den[p2, m2] stands for 1/(p2 - m2).  Note that in contrast to
PropagatorDenominator, p2 and m2 are the momentum and mass *squared*."

Num::usage =
"Num[expr] contains the numerator of a loop integral as a function of
the loop momentum q1.  This representation is used when calculating loop
integrals by the CutTools package."

DiracChain::usage =
"DiracChain[objs] is a chain of Dirac matrices contracted with the given
objects.  The integers 1, 5, 6, and 7 appearing as arguments denote 1,
gamma_5, (1 + gamma_5)/2, and (1 - gamma_5)/2, respectively."

WeylChain::usage =
"WeylChain[objs] is a chain of sigma matrices contracted with the given
objects.  The integers 6, 7 respectively denote upper and lower indices
at the given position, and -1 stands for epsilon, the spinor metric."

Spinor::usage =
"Spinor[p, m, s] is a spinor with momentum p and mass m, i.e. a solution
of the Dirac equation (pslash + s m) Spinor[p, m, s] = 0.  On screen,
particle spinors (s = 1) are printed as u[p, m], antiparticle spinors
(s = -1) as v[p, m].  Inside a WeylChain, Spinor denotes a 2-dimensional
Weyl spinor.  Whether it corresponds to the upper or lower half of the
4-dimensional Dirac spinor is determined by the index convention of the
WeylChain (fixed by arguments 6 or 7), propagated to the position of the
spinor."

DottedSpinor::usage =
"DottedSpinor[p, m, s] denotes the 2-dimensional conjugated spinor
corresponding to Spinor[p, m, s]."

Sigma::usage =
"Sigma[mu, nu] represents sigma_{mu nu} = 1/2 [gamma_mu, gamma_nu]."

e::usage =
"e[i] is the ith polarization vector."

ec::usage =
"ec[i] is the conjugate of the ith polarization vector."

z::usage =
"z[i] is the ith polarization vector in D - 4 dimensions."

zc::usage =
"zc[i] is the conjugate of the ith polarization vector in D - 4
dimensions."

eT::usage =
"eT[i] is the ith polarization tensor."

eTc::usage =
"eTc[i] is the conjugate of the ith polarization tensor."

k::usage =
"k[i] is the ith momentum."

SUNN::usage =
"SUNN specifies the N in SU(N), i.e. the number of colours."

S::usage =
"S is the Mandelstam variable s.  If k1 and k2 are the incoming momenta,
S = (k1 + k2)^2."

T::usage =
"T is the Mandelstam variable t.  If k1 denotes the first incoming and
k3 the first outgoing momentum, T = (k1 - k3)^2."

U::usage =
"U is the Mandelstam variable u.  If k2 denotes the first incoming and
k3 the second outgoing momentum, U = (k2 - k3)^2."

Dminus4::usage =
"Dminus4 represents the difference D - 4."


(* CalcFeynAmp and its options *)

CalcFeynAmp::usage =
"CalcFeynAmp[amps] calculates the Feynman amplitudes given in amps.  The
resulting expression is broken up into categories which are returned in
a list."

CalcLevel::usage =
"CalcLevel is an option of CalcFeynAmp.  It specifies the level (Classes
or Particles) at which to calculate the amplitudes. Automatic takes
Classes level, if available, otherwise Particles."

Dimension::usage =
"Dimension is an option of CalcFeynAmp.  It specifies the space-time
dimension in which to perform the calculation and can take the values D,
where dimensional regularization is used, and 4, where constrained
differential renormalization is used.  The latter method is equivalent
to dimensional reduction at the one-loop level."

OnShell::usage =
"OnShell is an option of CalcFeynAmp.  It specifies whether FORM should
put the external particles on their mass shell, i.e. apply ki^2 = mi^2."

Invariants::usage =
"Invariants is an option of CalcFeynAmp.  It specifies whether FORM
should introduce kinematical invariants, like the Mandelstam variables
for a 2 -> 2 process."

Transverse::usage =
"Transverse is an option of CalcFeynAmp.  It specifies whether FORM
should apply the transversality relations for polarization vectors
(ei.ki = 0)."

Normalized::usage =
"Normalized is an option of CalcFeynAmp.  It specifies whether FORM
should to exploit the normalization of the polarization vectors
(ei.ei^* = -1)."

MomSimplify::usage =
"MomSimplify is an option of CalcFeynAmp.  It specifies whether FORM
should try all possible permutations of the momentum conservation
equation on dot products and fermion chains in order to find the
shortest possible combination.  This might be slow, however."

InvSimplify::usage =
"InvSimplify is an option of CalcFeynAmp.  It specifies whether FORM
should try to simplify combinations of invariants as much as possible."

FermionChains::usage =
"FermionChains is an option of CalcFeynAmp.  It can take the three
values Chiral, VA, and Weyl, which specify how fermion chains are
returned by CalcFeynAmp.  Chiral and VA both select (4-dimensional)
Dirac chains, where the chiral decomposition is taken for Chiral and the
vector/axial-vector decomposition for VA.  Weyl selects (2-dimensional)
Weyl chains."

Chiral::usage =
"Chiral is a possible value for the FermionChains option of CalcFeynAmp. 
It instructs CalcFeynAmp to return fermion chains as left- and
right-handed (4-dimensional) Dirac chains."

VA::usage =
"VA is a possible value for the FermionChains option of CalcFeynAmp.  
It instructs CalcFeynAmp to return fermion chains as vector and
axial-vector parts of (4-dimensional) Dirac chains."

Weyl::usage =
"Weyl is a possible value for the FermionChains option of CalcFeynAmp. 
It instructs CalcFeynAmp to return fermion chains as (2-dimensional)
Weyl chains."

FermionOrder::usage =
"FermionOrder is an option of CalcFeynAmp.  It determines the ordering
of Dirac spinor chains in the output, i.e. requires FermionChains ->
Chiral or VA.  Possible values are None, Fierz, Automatic, Colour, or
an explicit ordering, e.g. {2, 1, 4, 3}.  None applies no reordering. 
Fierz applies the Fierz identities twice, thus simplifying the chains
but keeping the original order.  Colour applies the ordering of the
external colour indices (after simplification) to the spinors. 
Automatic chooses a lexicographical ordering."

Fierz::usage =
"Fierz is a possible value for the FermionOrder option of CalcFeynAmp. 
It instructs CalcFeynAmp to apply the Fierz identities twice, thus
simplifying the chains but keeping the original spinor order."

Colour::usage =
"Colour is a possible value for the FermionOrder option of CalcFeynAmp. 
It instructs CalcFeynAmp to bring the spinors into the same order as the 
external colour indices, i.e. \"Fermion flow follows colour flow\"."

InsertAt::usage =
"InsertAt is an option of CalcFeynAmp.  It can take the three values
Begin, Default, or End, which specify respectively whether the
insertions are applied at the beginning of the FORM code (this ensures
that all loop integrals are fully symmetrized), at the default place
(this is fastest), or after the FORM code, i.e. in Mathematica (this is
a workaround for the rare cases where the FORM code aborts due to very
long insertions)."

CutTools::usage =
"CutTools is an option of CalcFeynAmp.  It instructs CalcFeynAmp to
introduce loop integrals appropriate for the CutTools, rather than the
LoopTools package."

NoExpand::usage =
"NoExpand is an option of CalcFeynAmp.  NoExpand -> {sym1, sym2, ...}
specifies that sums containing any of sym1, sym2, ... are not expanded
during the FORM calculation."

AbbrScale::usage =
"AbbrScale is an option of CalcFeynAmp.  The automatically introduced
abbreviations are scaled by the square root of the provided factor for
every momentum they contain.  Thus AbbrScale -> S makes the
abbreviations dimensionless, which can be of advantage in some
applications, e.g. the treatment of resonances."

EditCode::usage =
"EditCode is a debugging option of CalcFeynAmp, HelicityME, and
PolarizationSum.  It edits the temporary file passed to FORM using the
editor command in $Editor."

RetainFile::usage =
"RetainFile is a debugging option of CalcFeynAmp, HelicityME, and
PolarizationSum.  When set to True, the temporary file containing the
FORM code is not removed after running FORM."


(* abbreviationing-related functions *)

Abbr::usage =
"Abbr[] returns a list of all abbreviations introduced so far.
Abbr[patt] returns a list of all abbreviations including the pattern
patt.  Patterns prefixed by ! (Not) are excluded."

GenericList::usage =
"GenericList[] returns a list of the substitutions made for the
computation of generic amplitudes."

Abbreviate::usage =
"Abbreviate[expr, minlevel] introduces abbreviations for all
subexpressions in expr (currently only sums are considered), starting at
level minlevel.  minlevel is an optional parameter and defaults to 2."

Deny::usage =
"Deny is an option of Abbreviate.  It specifies items which must not be
included in abbreviations."

Preprocess::usage =
"Preprocess is an option of Abbreviate.  It specifies a function to be
applied to all subexpressions before introducing abbreviations for
them."

$SubPrefix::usage =
"$SubPrefix specifies the prefix for subexpressions introduced by
Abbreviate, i.e. the Sub in Sub123."

Subexpr::usage =
"Subexpr[] returns a list of all subexpressions introduced by
Abbreviate."

ClearSubexpr::usage =
"ClearSubexpr[] clears the internal definitions of the subexpressions
introduced by Abbreviate."

RegisterSubexpr::usage =
"RegisterSubexpr[subexpr] registers a list of subexpressions such that
future invocations of Abbreviate will make use of them."

OptimizeAbbr::usage =
"OptimizeAbbr[abbr] optimizes the abbreviations in abbr by eliminating
common subexpressions."

$OptPrefix::usage =
"$OptPrefix specifies the prefix for additional abbreviations introduced
by OptimizeAbbr, i.e. the Opt in Opt123."

SubstSimpleAbbr::usage =
"SubstSimpleAbbr[expr, abbr] removes `simple' abbreviations from abbr
and substitutes them back into expr."

Pair::usage =
"Pair[a, b] represents the contraction of the two four-vectors or
Lorentz indices a and b."

Eps::usage =
"Eps[a, b, c, d] represents -I times the antisymmetric Levi-Civita
tensor epsilon_{abcd}.  The sign convention is epsilon^{0123} = +1."

ToSymbol::usage =
"ToSymbol[s...] concatenates its arguments into a new symbol."

ToArray::usage =
"ToArray[s] turns the symbol s into an array reference by taking it
apart into letters and digits, e.g. Var1234 becomes Var[1234]. 
ToArray[expr, s1, s2, ...] turns all occurrences of the symbols s1NNN,
s2NNN, etc. in expr into s1[NNN], s2[NNN], etc."

Renumber::usage =
"Renumber[expr, var1, var2, ...] renumbers all var1[n], var2[n], ... in
expr."

MaxDims::usage =
"MaxDims[args] returns a list of all distinct functions in args with the
highest indices that appear, e.g. MaxDims[foo[1, 2], foo[2, 1]] returns
{foo[2, 2]}."


(* miscellaneous functions *)

DenCollect::usage =
"DenCollect[expr] collects terms in expr whose denominators are
identical up to a numerical constant.  DenCollect[expr, wrap] applies
wrap to the collected numerators."

Pool::usage =
"Pool[expr] combines terms with common factors.  Unlike Factor, it looks
at the terms pairwise and can thus do a b + a c + d -> a (b + c) + d
fast.  Unlike Simplify, it does not modify b and c.  Pool[expr, wrap]
applies wrap to the (b + c) part."

ApplyUnitarity::usage =
"ApplyUnitarity[expr, mat, d, simp] simplifies expr by exploiting the
unitarity of the d-dimensional matrix mat.  The optional argument simp
specifies the simplification function to use internally and defaults to
FullSimplify."

OnSize::usage =
"OnSize[n1, f1, n2, f2, ..., fdef][expr] returns f1[expr] if
LeafCount[expr] < n1, f2[expr] if LeafCount[expr] < n2, etc., and
fdef[expr] if the expression is still larger.  If omitted, fdef defaults
to Identity."

OffShell::usage =
"OffShell[amps, i -> mi, ...] returns the FeynAmpList amps with the mass
of the ith external particle set to mi.  This will in general take
particle i off its mass shell since now ki^2 = mi^2 is fulfilled with
the new value of mi."

Combine::usage =
"Combine[amp1, amp2, ...] combines the amplitudes amp1, amp2, ... which
can be either FeynAmpList or Amp objects, i.e. Combine works before and
after CalcFeynAmp."

MultiplyDiagrams::usage =
"MultiplyDiagrams[func][amp] multiplies the diagrams in amp with the
factor returned by the function func.  The latter is invoked for each
diagram either as func[amplitude] (for a fully inserted diagram), or as
func[generic amplitude, insertion]."

TagDiagrams::usage =
"TagDiagrams[amp] tags each diagram in amp with an identifier of the
form Diagram[number], where number runs sequentially through the
diagrams at all levels.  This makes it possible to locate the
contribution of individual diagrams in the final CalcFeynAmp output."

Diagram::usage =
"Diagram[number] is the identifier used to tag a single diagram by
TagDiagrams."

ClearProcess::usage =
"ClearProcess[] is necessary to clear internal definitions before
calculating a process with a different kinematical set-up."

DiagramType::usage =
"DiagramType[diag] returns the number of denominators not containing 
the integration momentum."

FermionicQ::usage =
"FermionicQ[diag] gives True for a diagram containing fermions and 
False otherwise."

IndexIf::usage =
"IndexIf[cond, a, b] is identical to If[cond, a, b], except that a and
b are not held unevaluated.  IndexIf[cond, a] is equivalent to
IndexIf[cond, a, 0]."

IndexDiff::usage =
"IndexDiff[i, j] is the same as 1 - IndexDelta[i, j]."

ToIndexIf::usage =
"ToIndexIf[expr] converts all IndexDeltas and IndexDiffs in expr to
IndexIf, which will be written out as if-statements in the generated
Fortran code.  ToIndexIf[expr, patt] operates only on indices matching
patt.  If patt is a string, e.g. \"Glu*\", it is first expanded to all
matching symbols."

Neglect::usage =
"Neglect[sym] = 0 makes FORM replace sym = 0 except when it appears in
negative powers or in loop integrals."

Square::usage =
"Square[m] = m2 makes FORM replace all m^2 by m2."

ColourSimplify::usage =
"ColourSimplify[expr] simplifies the colour objects in expr.
ColourSimplify[plain, conj] simplifies the colour objects in
(plain conj^*)."

ColourGrouping::usage =
"ColourGrouping[tops] returns a list of parts of the inserted topologies
tops, grouped according to their colour structures."


(* FeynCalc compatibility functions *)

FeynCalcGet::usage =
"FeynCalcGet[mask] reads files produced with FeynCalc.  mask is taken 
as input to the Mathematica function FileNames, so it might be
FeynCalcGet[\"file.m\"] or FeynCalcGet[\"*.m\"] or FeynCalcGet[\"*.m\",
\"~/feyncalcfiles\"]."

FeynCalcPut::usage =
"FeynCalcPut[expr, file] writes expr to file in FeynCalc format."


(* finiteness checks *)

UVDivergentPart::usage =
"UVDivergentPart[expr] returns expr with all loop integrals replaced
by their UV-divergent part.  The divergence itself is denoted by
Divergence, so to assert that expr is UV-finite, one can check if
FreeQ[Expand[UVDivergentPart[expr], Divergence], Divergence] is True."

Divergence::usage =
"Divergence stands for the dimensionally regularized divergence
2/(4 - D) of loop integrals.  It is used by the function
UVDivergentPart."


(* matrix elements *)

HelicityME::usage =
"HelicityME[plain, conj] calculates the helicity matrix elements for all
combinations of spinor chains that appear in the expression
(plain conj^*).  Terms of this kind arise in the calculation of the
squared matrix element, where typically plain is the one-loop result
and conj the Born expression.  The arguments do not necessarily have to
be amplitudes since they are only used to determine which spinor chains
to select from the abbreviations.  The symbol All can be used to select
all spinor chains currently defined in the abbreviations."

ColourME::usage =
"ColourME[plain, conj] calculates the colour matrix elements.  ColourME
is very similar to HelicityME, except that it computes the matrix
elements for SU(N) objects, not for spinor chains."

All::usage =
"All as an argument of HelicityME and ColourME indicates that all spinor
chains or SUNT objects currently defined in the abbreviations should be
used instead of just those appearing in the argument."

Source::usage =
"Source is an option of HelicityME, ColourME, and PolarizationSum.  
It specifies from where the abbreviations used to calculate the matrix
elements are taken."

Hel::usage =
"Hel[i] is the helicity of the ith external particle.  It can take the
values +1, 0, -1, where 0 stands for an unpolarized particle."

s::usage =
"s[i] is the ith helicity reference vector."

Mat::usage =
"Mat[Fi SUNi] is a matrix element in an amplitude, i.e. an amplitude is
a linear combination of Mat objects.\n Mat[Fi, Fj] appears in the
squared matrix element and stands for the product of the two arguments,
Fi Fj^*.  Such expressions are calculated by HelicityME and ColourME."

Lor::usage =
"Lor[i] is a contracted Lorentz index in a product of Dirac chains."

SquaredME::usage =
"SquaredME[plain, conj] returns the matrix element 
(plain Conjugate[conj]).  This performs a nontrivial task only for 
fermionic amplitudes: the product of two fermionic amplitudes\n
    M1 = a1 F1 + a2 F2 + ... and\n
    M2 = b1 F1 + b2 F2 + ... is returned as\n
    M1 M2^* = a1 b1^* Mat[F1, F1] + a2 b1^* Mat[F2, F1] + ...\n
The special case of plain === conj can be written as SquaredME[plain]
which is of course equivalent to SquaredME[plain, plain]."

RealQ::usage =
"RealQ[sym] is True if sym represents a real quantity which means in
particular that Conjugate[sym] = sym."

PolarizationSum::usage =
"PolarizationSum[expr] sums expr over the polarizations of external
gauge bosons.  It is assumed that expr is the squared amplitude into
which the helicity matrix elements have already been inserted. 
Alternatively, expr may also be given as an amplitude directly, in which
case PolarizationSum will first invoke SquaredME and HelicityME (with
Hel[_] = 0) to obtain the squared amplitude."

GaugeTerms::usage =
"GaugeTerms is an option of PolarizationSum.  With GaugeTerms -> False,
the gauge-dependent terms in the polarization sum, which should
eventually cancel in gauge-invariant subsets of diagrams, are omitted
from the beginning."

eta::usage =
"eta[i] is a vector that defines a particular gauge via Pair[eta[i],
e[i]] = 0.  It is introduced by PolarizationSum for massless particles,
where the sum over e[i][mu] ec[i][nu] is gauge dependent.  Only for
gauge-invariant subsets of diagrams should the dependence on eta[i]
cancel.  eta obeys Pair[eta[i], k[i]] != 0 and Pair[eta[i], e[i]] = 0."


(* writing out Fortran code *)

SetupCodeDir::usage =
"SetupCodeDir[dir] installs the driver programs necessary to compile the
Fortran code generated by WriteSquaredME and WriteRenConst in the
directory dir.  Customized versions of the drivers are taken from the
directory pointed to by the Drivers option and take precedence over the
default versions from $DriversDir.  Drivers already in dir are not
overwritten."

Drivers::usage =
"Drivers is an option of SetupCodeDir.  Drivers points to a directory
containing customized versions of the driver programs necessary for
compiling the generated Fortran code.  This directory need not contain
all driver programs: files not contained therein are taken from the
default directory $DriversDir."

WriteSquaredME::usage =
"WriteSquaredME[tree, loop, me, abbr, ..., dir] writes out Fortran code
to compute the squared matrix element for a process whose tree-level and
one-loop contributions are given in the first and second argument,
respectively.  All further arguments except the last specify the
necessary matrix elements and abbreviations.  The last argument dir
finally gives the path to write the generated code to."

ExtraRules::usage =
"ExtraRules is an option of WriteSquaredME.  Rules given here will be
applied before the loop integrals are abbreviated."

LoopSquare::usage =
"LoopSquare is an option of WriteSquaredME.  It specifies whether to 
add the square of the 1-loop amplitude, |M_1|^2, to the result in the
SquaredME subroutine.  This term is of order alpha^2 with respect to the
tree-level contribution, |M_0|^2.  Usually one takes into account only
the interference term, 2 Re M_0^* M_1, which is of order alpha."

Folder::usage =
"Folder is an option of WriteSquaredME and WriteRenConst.  It specifies
the folder into which the generated files are written."

SymbolPrefix::usage =
"SymbolPrefix is an option of WriteSquaredME and WriteRenConst.  
It specifies a string which is prepended to externally visible symbols 
in the generated Fortran code to prevent collision of names when 
several processes are linked together."


(* renormalization constants *)

FindRenConst::usage =
"FindRenConst[expr] returns a list of all renormalization constants
found in expr including those needed to compute the former."

CalcRenConst::usage =
"CalcRenConst[expr] calculates the renormalization constants appearing
in expr."

WriteRenConst::usage =
"WriteRenConst[expr, dir] calculates the renormalization constants
appearing in expr and generates a Fortran program from the results.  
The resulting files (the Fortran program itself and the corresponding
declarations) are written to the directory dir.  The names of the files
are determined by the RenConstFile option."

InsertFieldsHook::usage =
"InsertFieldsHook[tops, proc] is the function called by SelfEnergy and
DSelfEnergy to insert fields into the topologies tops for the process
proc.  It is normally equivalent to InsertFields, but may be redefined
to change the diagram content of certain self-energies."

ClearSE::usage =
"ClearSE[] clears the internal definitions of already calculated
self-energies."

$PaintSE::usage =
"$PaintSE determines whether SelfEnergy paints the diagrams it generates
to compute the self-energies.  $PaintSE can be True, False, or a string
which indicates that the output should be saved in a PostScript file
instead of being displayed on screen, and is prepended to the filename."


(* low-level Fortran output functions *)

ToList::usage =
"ToList[expr] returns a list of summands of expr."

MkDir::usage =
"MkDir[\"dir1\", \"dir2\", ...] makes sure the directory dir1/dir2/...
exists, creating the individual subdirectories dir1, dir2, ... as
necessary."

ToFortran::usage =
"ToFortran[expr] returns the Fortran form of expr as a string."

OpenFortran::usage =
"OpenFortran[file] opens file for writing in Fortran format."

TimeStamp::usage =
"TimeStamp[] returns a string with the current date and time."

BlockSplit::usage =
"BlockSplit[var -> expr] tries to split the calculation of expr into
subexpressions each of which has a leaf count less than $BlockSize."

FileSplit::usage =
"FileSplit[exprlist, mod, writemod, writeall] splits exprlist into
batches with leaf count less than $FileSize.  If there is only one
batch, writemod[batch, mod] is invoked to write it to file.  Otherwise,
writemod[batch, modN] is invoked on each batch, where modN is mod
suffixed by a running number, and in the end writeall[mod, res] is
called, where res is the list of writemod return values.  The optional
writeall function can be used e.g. to write out a master subroutine
which invokes the individual modules."

RuleAdd::usage =
"RuleAdd[var, expr] is equivalent to var -> var + expr."

PrepareExpr::usage =
"PrepareExpr[{var1 -> expr1, var2 -> expr2, ...}] prepares a list of
variable assignments for write-out to a Fortran file. Expressions with a
leaf count larger than $BlockSize are split into several pieces, as in\n
\tvar = part1\n\
\tvar = var + part2\n\
\t...\n
thereby possibly introducing temporary variables for subexpressions. 
The output is a FortranExpr[vars, tmpvars, exprlist] object, where vars
are the original and tmpvars the temporary variables introduced by
PrepareExpr."

WriteExpr::usage =
"WriteExpr[file, exprlist] writes a list of variable assignments in
Fortran format to file.  The exprlist can either be a FortranExpr object
or a list of expressions of the form {var1 -> expr1, var2 -> expr2,
...}, which is first converted to a FortranExpr object using
PrepareExpr.  WriteExpr returns a list of the subexpressions that were
actually written."

HornerStyle::usage =
"HornerStyle is an option of WriteExpr.  It specifies whether
expressions are arranged in Horner form before writing them out as
Fortran code."

Type::usage =
"Type is an option of WriteExpr.  If a string is given, e.g. Type ->
\"double precision\", WriteExpr writes out declarations of that type for
the given expressions.  Otherwise no declarations are produced."

TmpType::usage =
"TmpType is an option of WriteExpr.  It is the counterpart of Type for
the temporary variables.  TmpType -> Type uses the settings of the Type
option."

RealArgs::usage =
"RealArgs is an option of WriteExpr.  It specifies a list of functions
for which all numerical arguments must be given as reals (double
precision) in Fortran."

Newline::usage =
"Newline is an option of WriteExpr.  It specifies a string to be printed
after each Fortran statement."

Optimize::usage =
"Optimize is an option of PrepareExpr and WriteExpr.  With Optimize -> 
True, variables are introduced for subexpressions which are used more 
than once."

MinLeafCount::usage =
"MinLeafCount is an option of PrepareExpr, WriteExpr, and Abbreviate. 
It specifies the minimum LeafCount a common subexpression must have in
order that a variable is introduced for it."

DebugLines::usage =
"DebugLines is an option of PrepareExpr and WriteExpr.  It specifies
whether debugging statements are written out for each variable.  If
instead of True a string is given, the debugging messages are prefixed
by this string.  Debugging statements use the preprocessor macro DEB
for write-out and are enabled, at compile time, by defining the
preprocessor variable DEBUG."

FinalTouch::usage =
"FinalTouch is an option of PrepareExpr and WriteExpr.  It specifies a
function which is applied to each final subexpression, such as will then
be written out to the Fortran file."

FortranExpr::usage =
"FortranExpr[vars, tmpvars, exprlist] is the output of PrepareExpr and
contains a list of expressions ready to be written to a Fortran file,
where vars are the original variables and tmpvars are temporary
variables introduced in order to shrink individual expressions to a size
small enough for Fortran."

DebugLine::usage =
"DebugLine[var] emits a debugging statement (print-out of variable var)
when written to a Fortran file with WriteExpr.  DebugLine[var, tag]
prefixes the debugging message with the string \"tag\"."

SplitSums::usage =
"SplitSums[expr] splits expr into a list of expressions such that index
sums (marked by SumOver) always apply to the whole of each part. 
SplitSums[expr, wrap] applies wrap to the coefficients of the SumOver."

ToDoLoops::usage =
"ToDoLoops[list, ifunc] splits list into patches which must be summed
over the same set of indices.  ifunc is an optional argument, where
ifunc[expr] must return the indices occurring in expr."

DoLoop::usage =
"DoLoop[expr, ind] is a symbol introduced by ToDoLoops indicating that
expr is to be summed over the indices ind."

Dim::usage =
"Dim[i] returns the highest value the index i takes on, as determined
from the amplitude currently being processed."

MoveDepsRight::usage =
"MoveDepsRight[r1, ..., rn] shuffles variable definitions (var -> value)
among the lists of rules ri such that the definitions in each list do
not depend on definitions in ri further to the left.  For example,
MoveDepsRight[{a -> b}, {b -> 5}] produces {{}, {b -> 5, a -> b}}, i.e.
it moves a -> b to the right list because that depends on b."

MoveDepsLeft::usage =
"MoveDepsLeft[r1, ..., rn] shuffles variable definitions (var -> value)
among the lists of rules ri such that the definitions in each list do
not depend on definitions in ri further to the right.  For example,
MoveDepsLeft[{a -> b}, {b -> 5}] produces {{b -> 5, a -> b}, {}}, i.e.
it moves b -> 5 to the left list because that depends on b."

OnePassOrder::usage =
"OnePassOrder[r] orders a list of interdependent rules such that the
definition of each item (item -> ...) comes before its use in the
right-hand sides of other rules."

$OnePassDebug::usage =
"When OnePassOrder detects a recursion among the definitions of a list,
it deposits the offending rules in an internal format in $OnePassDebug
as debugging hints."

SubroutineDecl::usage =
"SubroutineDecl[name] returns a string with the declaration of the
Fortran subroutine name."

VarDecl::usage =
"VarDecl[v, t] returns a string with the declaration of v as variables
of type t in Fortran."

CommonDecl::usage =
"CommonDecl[v, t, c] returns a string with the declaration of v as
variables of type t and members of the common block c in Fortran."

DoDecl::usage =
"DoDecl[v, m] returns two strings with the do/enddo declarations of a 
Fortran loop over v from 1 to m.  DoDecl[v, {a, b}] returns the same for 
a loop from a to b.  DoDecl[v] invokes Dim[v] to determine the upper 
bound on v."

CallDecl::usage =
"CallDecl[names] returns a string with the invocations of the 
subroutines names in Fortran, taking into account possible loops
indicated by DoLoop."

$FortranPrefix::usage =
"$FortranPrefix is a string prepended to all externally visible symbols
in the generated Fortran code to avoid symbol collisions."


(* symbols used in the Fortran code *)

Ctree::usage =
"Ctree[Fi] is the ith form factor (the coefficient of Fi) of the
tree-level amplitude."

Cloop::usage =
"Cloop[Fi] is the ith form factor (the coefficient of Fi) of the
one-loop amplitude."

SInvariant::usage =
"SInvariant[ki, kj] represents the s-type (invariant-mass type)
invariant formed from the momenta ki and kj, i.e. s_{ij} = (ki + kj)^2."

TInvariant::usage =
"TInvariant[ki, kj] represents the t-type (momentum-transfer type)
invariant formed from the momenta ki and kj, i.e. t_{ij} = (ki - kj)^2."

DCONJG::usage =
"DCONJG[z] takes the complex conjugate of z in Fortran."

DBLE::usage =
"DBLE[z] takes the real part of z in Fortran."

DIMAG::usage =
"DIMAG[z] takes the imaginary part of z in Fortran."

exp::usage =
"exp[x] is the exponential function in Fortran."

cI::usage =
"cI represents the imaginary unit in Fortran."

Bval::usage =
"Bval is the array containing the cached two-point integrals in
LoopTools."

Bget::usage =
"Bget computes all two-point coefficients in LoopTools."

Cval::usage =
"Cval is the array containing the cached three-point integrals in
LoopTools."

Cget::usage =
"Cget computes all three-point coefficients in LoopTools."

Dval::usage =
"Dval is the array containing the cached four-point integrals in
LoopTools."

Dget::usage =
"Dget computes all four-point coefficients in LoopTools."

Eval::usage =
"Eval is the array containing the cached five-point integrals in
LoopTools."

Eget::usage =
"Eget computes all five-point coefficients in LoopTools."

Fval::usage =
"Fval is the array containing the cached six-point integrals in a future
version of LoopTools."

Fget::usage =
"Fget computes all six-point coefficients in a future version of
LoopTools."

SxS::usage =
"SxS[s1, s2] is the Fortran function which computes s1.s2, the direct
product of the two Weyl spinors s1 and s2."

SeS::usage =
"SeS[s1, s2] is the Fortran function which computes s1.eps.s2, the SU(2)
product of the two Weyl spinors s1 and s2."

VxS::usage =
"VxS[v, s] is the Fortran function which computes sigma[v].s, the direct
product of the vector v contracted with sigma and the Weyl spinor s."

VeS::usage =
"VeS[v, s] is the Fortran function which computes sigma[v].eps.s, the
SU(2) product of the vector v contracted with sigma and the Weyl spinor
s."

BxS::usage =
"BxS[v, s] is the Fortran function which computes sigmabar[v].s, the
direct product of the vector v contracted with sigma-bar and the Weyl
spinor s."

BeS::usage =
"BeS[v, s] is the Fortran function which computes sigmabar[v].eps.s, 
the SU(2) product of the vector v contracted with sigma-bar and the 
Weyl spinor s."

SplitChain::usage =
"SplitChain[w] splits WeylChain[w] into primitive operations SxS, SeS,
VxS, VeS, BxS, BeS for computation."


(* system variables *)

$Editor::usage =
"$Editor specifies the editor command line used in debugging FORM code."

$FormCalc::usage =
"$FormCalc contains the version number of FormCalc."

$FormCalcDir::usage =
"$FormCalcDir points to the directory from which FormCalc was loaded."

$FormCalcProgramDir::usage =
"$FormCalcProgramDir points to the directory which contains the FormCalc
program files."

$ReadForm::usage =
"$ReadForm contains the location of the ReadForm executable."

$ReadFormDebug::usage =
"$ReadFormDebug specifies debugging flags to ReadForm."

$FormCmd::usage =
"$FormCmd gives the name of the actual FORM executable.  It may contain 
a path."

$DriversDir::usage =
"$DriversDir is the path where the driver programs for the generated
Fortran code are located."

$BlockSize::usage =
"$BlockSize is the maximum LeafCount a single Fortran statement written
out by WriteExpr may have.  Any expression with LeafCount > $BlockSize
will be chopped up before being written to the Fortran file."

$FileSize::usage =
"$FileSize gives the maximum LeafCount the expressions in a single
Fortran file may have.  If the expressions grow larger than $FileSize,
the file is split into several pieces."


Begin["`Private`"]

$FormCalc = 5.4

$FormCalcDir = DirectoryName[ File /.
  FileInformation[System`Private`FindFile[$Input]] ]

$FormCalcProgramDir = ToFileName[{$FormCalcDir, "FormCalc"}]


$ReadForm = ToFileName[{$FormCalcDir, $SystemID}, "ReadForm"];

$ReadFormDebug = 0

Check[
  Install[$ReadForm],
  ReadForm::notcompiled = "The ReadForm executable `` could not be \
installed.  Did you run the compile script first?";
  Message[ReadForm::notcompiled, $ReadForm];
  Abort[] ]


$NumberMarks = False

Off[General::spell1, General::spell]


(* generic functions *)

ParseOpt[func_, opt___] :=
Block[ {names = First/@ Options[func]},
  Message[func::optx, #, func]&/@
    Complement[First/@ {opt}, names];
  names /. {opt} /. Options[func]
]


ToSymbol[x__] := ToExpression[ StringJoin[ToString/@ Flatten[{x}]] ]


Attributes[ToArray] = {Listable}

ToArray[sym_Symbol] :=
Block[ {t = ToString[sym], p},
  p = Position[DigitQ/@ Characters[t], False][[-1, 1]];
  ToExpression[StringTake[t, p]] @ ToExpression[StringDrop[t, p]]
]

ToArray[other_] = other

ToArray[expr_, vars__] :=
Block[ {v = ToString/@ Flatten[{vars}], rules, t, p, h},
  rules = (
    t = ToString[#];
    p = Position[DigitQ/@ Characters[t], False][[-1,1]];
    h = StringTake[t, p];
    If[ MemberQ[v, h],
      # -> ToExpression[h] @ ToExpression[StringDrop[t, p]],
      {} ]
  )&/@ Symbols[expr];
  expr /. Dispatch[Flatten[rules]]
]


Renumber[expr_, vars__] :=
Block[ {v = Flatten[{vars}], old, new},
  old = Union[Cases[expr, #[__], Infinity]]&/@ v;
  new = MapThread[Array, {v, Length/@ old}];
  expr /. Dispatch[Thread[Flatten[old] -> Flatten[new]]]
]


MaxDims[args__] :=
  listmax/@ Split[Union[Flatten[{args}]], Head[#1] === Head[#2]&];

listmax[{s__Symbol}] := s

listmax[l_] := l[[1,0]]@@ MapThread[Max, List@@@ l]


Attributes[ToForm] = {Listable}

ToForm[x_String] = x

ToForm[x_] := ToString[x, InputForm]


ToSeq[li_List] := StringTake[ToString[li, InputForm], {2, -2}]

ToSeq[x_] := ToForm[x]


ToBool[True] = "1"

ToBool[___] = "0"


ToFortran[x_String] = x

ToFortran[x_List] := StringTake[ToString[x, FortranForm], {6, -2}]

ToFortran[x_] := ToString[x, FortranForm]


ToCat[n_, {}] := Table[{}, {n}]

ToCat[_, li_] := Flatten/@ Transpose[li]


Symbols[expr_] := Union[Cases[expr, _Symbol, {-1}]]


FromPlus[h_, p_Plus] := h@@ p

FromPlus[_, other_] = other


numadd[term_] := numadd[
  Numerator[term],
  Denominator[term] //Simplify ]

numadd[n_, x_?NumberQ d_] := num[d] += n/x

numadd[n_, d_] := num[d] += n

DenCollect[p_Plus, wrap_:Identity] :=
Block[ {num},
  _num = 0;
  numadd/@ p;
  _num =.;
  Plus@@ (wrap[#2]/#1[[1,1]] &)@@@ DownValues[num]
]

DenCollect[other_, wrap_:Identity] := wrap[other]


Pool[expr_, wrap_:Identity] := expr /.
  p_Plus :> ploos[wrap]@@ Cases[p, _Times] +
    DeleteCases[p, _Times] /; LeafCount[p] > 10

ploos[wrap_][a_, r__] :=
Block[ {pos = 0, lcmin, lcmax, lc, ov, ovmax, ovpos, ploos},
  lcmin = Floor[LeafCount[a]/3];
  lcmax = -Infinity;
  Scan[ (
    ++pos;
    lc = LeafCount[ov = Intersection[a, #]];
    If[ lc > lcmax,
      lcmax = lc; ovpos = pos; ovmax = ov;
      If[ lc > lcmin, Return[] ] ] )&, {r} ];
  If[ lcmax < 5,
    a + ploos[wrap][r],
  (* else *)
    ovmax wrap[a/ovmax + {r}[[ovpos]]/ovmax] +
      Drop[ploos[wrap][r], {ovpos}] ]
]

ploos[_][other___] := Plus[other]


Attributes[usq] = {Orderless}

usq/: usq[a__][ik__] + usq[b__][ik__] := usq[a, b][ik]

usq/: usq[a__][h_, i_, i_] + usq[i_][h_, k_, k_] := usq[a, k][h, i, i]


usum[i___, _, _, _, _] := {i} /; uexpr[[i, 0]] === Plus

_usum = Sequence[]


ApplyUnitarity[expr_, U_, dim_Integer, simp_:FullSimplify] :=
Block[ {ux, uexpr, pos},
  Evaluate[ux@@ Range[dim]] = KroneckerDelta[##2] &;
  ux[a__] := With[ {cpl = usq@@ Complement[Range[dim], {a}]},
    ux[a] = KroneckerDelta[##2] - cpl[##] &
  ] /; Length[{a}] > dim/2;
  ux[other__] := usq[other];

  uexpr = expr //. {
    (u:U[i_, j_])^n_. (uc:Conjugate[U[k_, j_]])^nc_. :>
      (usq[j][1, i, k]^# u^(n - #) uc^(nc - #) &) @ Min[n, nc],
    (u:U[j_, k_])^n_. (uc:Conjugate[U[j_, i_]])^nc_. :>
      (usq[j][2, i, k]^# u^(n - #) uc^(nc - #) &) @ Min[n, nc]
  } /. usq -> ux;

  pos = usum@@@ Position[uexpr, usq];
  pos = Select[pos, FreeQ[pos, Append[#, __]]&];

  MapAt[simp, uexpr, pos] /. usq -> ux /. {
    usq[a__][1, i_, k_] -> Plus@@ (U[i, #] Conjugate[U[k, #]] &)/@ {a},
    usq[a__][2, i_, k_] -> Plus@@ (U[#, k] Conjugate[U[#, i]] &)/@ {a} }
]


lt[f_, Infinity] = {_, f}

lt[Infinity, Infinity] = {_, Identity}

lt[n_, f_] := {x_ /; x < n, f}

ToSwitch[args__] := Switch[LeafCount[#], args][#]&

OnSize[args__] := Level[
  lt@@@ Partition[{args, Infinity, Infinity}, 2],
  {2}, ToSwitch ]


DiagramType[a_FeynAmp] := Count[a[[3]] /. _FeynAmpDenominator -> 1,
  _PropagatorDenominator, Infinity]


FermionicQ[a_FeynAmp] := !FreeQ[a[[3]], FermionChain | MatrixTrace]


Attributes[IndexDiff] = Attributes[IndexDelta] = {Orderless}


IndexIf[cond_, a_] := IndexIf[cond, a, 0]

IndexIf[True, a_, _] = a

IndexIf[False, _, b_] = b

IndexIf[_, a_, a_] = a

IndexIf[cond1_, IndexIf[cond2_, a_, 0], 0] :=
  IndexIf[cond1 && cond2, a, 0]

IndexIf[cond1_, IndexIf[cond2_, 0, a_], 0] :=
  IndexIf[cond1 && !cond2, a, 0]

IndexIf[cond1_, 0, IndexIf[cond2_, 0, a_]] :=
  IndexIf[cond1 && cond2, 0, a]

IndexIf[cond1_, 0, IndexIf[cond2_, a_, 0]] :=
  IndexIf[cond1 && !cond2, 0, a]


Off[Optional::opdef]

ToIndexIf[expr_, s_String] :=
  ToIndexIf[expr, Alternatives@@ Names[s]]

ToIndexIf[expr_, patt_:_] :=
  Fold[ singleIf, expr, Union @ Cases[expr,
    (IndexDelta | IndexDiff)[i:patt..] -> {i}, Infinity] ]

singleIf[expr_, {i__}] := expr /.
  { IndexDelta[i] -> suck[1, 1],
    IndexDiff[i] -> suck[2, 1] } /.
  a_. suck[1, x_] + a_. suck[2, y_] -> a IndexIf[Equal[i], x, y] /.
  suck[h_, x_] :> IndexIf[{Equal, Unequal}[[h]][i], x]
(*
  suck[h_, x_] :> IndexIf@@ ReplacePart[{Equal[i], 0, 0}, x, h]
*)

suck/: r_ suck[h_, x_] := suck[h, r x] /; FreeQ[r, Mat (*| SumOver*)]

suck/: suck[h_, x_] + suck[h_, y_] := suck[h, x + y]

(* suck/: suck[h_, x_] + y_ := suck[3 - h, y] /; x + y == 0 *)


(* preparations for FORM *)

ExtWF = {e, ec, z, zc, eT, eTc}

ConjWF = ({#1 -> #2, #2 -> #1}&)@@@ Partition[ExtWF, 2] //Flatten

KinVecs = {eta, e, ec, z, zc, k}

KinTens = {eT, eTc}

KinObjs = Join[KinVecs, KinTens]
	(* note: KinObjs determines the order in which vectors
	   and tensors appear in FORM and hence ultimately in
	   functions like Pair and Eps *)


Attributes[KinFunc] = {HoldAll}

KinFunc[args__] := Function[Evaluate[KinObjs], args]


FromFormRules = Outer[ ToSymbol["FormCalc`", #2, #1] -> #2[#1] &,
  Range[8], KinObjs ]

FormKins = Apply[#1&, FromFormRules, {2}]

FromFormRules = Flatten[FromFormRules]


MomThread[p_Symbol, foo_] := foo[p]

MomThread[p_, foo_] := Replace[MomReduce[p], k_Symbol :> foo[k], {-1}]


MomReduce[p_Plus] := Fewest[p, p + MomSum, p - MomSum]

MomReduce[p_] = p


Fewest[a_, b_, r___] := Fewest[a, r] /; Length[a] <= Length[b]

Fewest[_, b__] := Fewest[b]

Fewest[a_] = a


iname[type_, n_] := iname[type, n] =
  ToSymbol[StringTake[ToString[type], 3], n]


Attributes[idelta] = {Orderless}

idelta[c1:Index[Colour, _], c2_] := SUNT[c1, c2]

idelta[g1:Index[Gluon, _], g2_] := 2 SUNT[g1, g2, 0, 0]

idelta[x__] := IndexDelta[x]


ieps[c__] := Block[{eps = SUNEps[c]}, eps /; !FreeQ[eps, Index[Colour, _]]]

ieps[x__] := IndexEps[x]


isum[expr_, i_, r__] := isum[isum[expr, i], r]

isum[expr_, {i_, r_}] := r expr /; FreeQ[expr, i]

isum[expr_, {i_, r_}] :=
Block[ {dummy = Unique[ToString[i]]},
  indices = {indices, dummy};
  (expr /. i -> dummy) SumOver[dummy, r, Renumber]
]


sumover[i:Index[Colour | Gluon, _], r__] := SUNSum[i, r]

sumover[other__] := SumOver[other]

SUNSum[_, _, External] = 1


KinFunc[
  pol[_, k, mu:Index[EpsilonScalar, _]] = z[mu];
  polc[_, k, mu:Index[EpsilonScalar, _]] = zc[mu];
  pol[_, k, mu_] = e[mu];
  polc[_, k, mu_] = ec[mu];
  pol[_, k, mu__] = eT[mu];
  polc[_, k, mu__] = eTc[mu] ]@@@ FormKins

Conjugate[pol] ^= polc


Attributes[scalar] = {Orderless}

scalar[0, _] = 0

scalar[a_Symbol, b_Symbol] := a . b

scalar[a_, p:_[__]] := MomThread[p, scalar[a, #]&]


prop[0, m_Symbol] = -1/m^2

prop[p_, m_] := prop[-p, m] /; !FreeQ[p, -q1]

prop[p_, m_] := Den[p, m^2]


Attributes[loop] = {Orderless}

loop[a___, d_[p_, m1_], _[p_, m2_], b___] :=
  (loop[a, d[p, m1], b] - loop[a, d[p, m2], b])/Factor[m1 - m2]

loop[d__] := I Pi^2 Level[ Thread[{d}, Den], {2},
  {A0i, B0i, C0i, D0i, E0i, F0i}[[ Length[{d}] ]] ]


noncomm[p_Plus] := noncomm/@ p

noncomm[g_] := g ga[] /; FreeQ[g, ga | Spinor]

noncomm[g_] = g

noncomm[g__] := NonCommutativeMultiply[g]


CurrentProcess = Sequence[]


Neglect[m_] = m

FormPatt[_[_, m]] = {}

FormPatt[_?NumberQ, _] = {}

FormPatt[_[_[_[lhs_]], rhs_]] := FormPatt[lhs, rhs]

FormPatt[lhs_Alternatives, rhs_] := FormPatt[#, rhs]&/@ List@@ lhs

FormPatt[lhs_, rhs_] :=
Block[ {c = 96, newlhs, newrhs = rhs},
  newlhs = lhs /.
    {Blank -> FormArg, BlankSequence | BlankNullSequence -> FormArgs} /.
    Pattern -> ((newrhs = newrhs /. #1 -> #2; #2)&);
  (newlhs /. patt[x_] :> x <> "?") -> (newrhs /. patt[x_] -> x)
]

FormArg[h_:Identity] := h[patt["FC" <> FromCharacterCode[++c]]]

FormArgs[h_:Identity] := h["?" <> FromCharacterCode[++c]]


OrdSq[r:_[_, rhs_]] := {{}, r} /; VectorQ[lhs, FreeQ[rhs, #]&]

OrdSq[r_] := {r, {}}

SortSq[dv_] :=
Block[ {lhs = #[[1, 1, 1]]&/@ dv},
  Flatten[Transpose[OrdSq/@ dv]]
]


Attributes[Inv] = {Listable}

Inv[i_, j_] :=
Block[ {s = signs[[i]] signs[[j]], ki = Moms[[i]], kj = Moms[[j]], inv},
  inv = If[ legs === 3, dot[#, #]& @ Moms[[3]], Invariant[s, i, j] ];
  dot[ki, kj] = s/2 inv - s/2 dot[ki, ki] - s/2 dot[kj, kj];
  inv
]


Invariant[1, 1, 2] = S

Invariant[-1, 1, 3] = T

Invariant[-1, 2, 3] = U

Invariant[pm_, i_, j_] := Invariant[pm, i, j] =
  ToSymbol["FormCalc`", FromCharacterCode[(167 - pm)/2], i, j]


OtherProd[{k1___, k_}, {pm1___, pm_}, zero_] :=
  MapThread[
    (dot[#1, k] = -pm (Plus@@ ({pm1} dot[#1, {k1}]) - #2 zero))&,
    {{k1}, {pm1}} ]


(* global variables set here:
   CurrentProcess, CurrentScale, CurrentFlags,
   FormProcs, FormSymbols,
   Moms, MomSum, InvSum, PairRules *)

DeclareProcess[proc_, scale_,
  flags:{onshell_, inv_, transv_, norm_, momsimp_, invsimp_}] :=
Block[ {masses, neglect, square, dot, n,
invproc = {}, invs = {}, kikj = {}, eiki = {}, eiei = {}},

  CurrentProcess = proc;
  CurrentScale = scale;
  CurrentFlags = flags;
  FormProcs = {};
  MomSum = InvSum = 0;

  neglect = FormPatt/@ DownValues[Neglect];
  square = FormPatt/@ SortSq[DownValues[Square]];

  signs = Flatten[{1&/@ proc[[1]], -1&/@ proc[[2]]}];
  masses = Level[proc, {2}]^2;
  legs = Length[masses];
  kins = Take[FormKins, legs];

  Moms = KinFunc[k]@@@ kins;
  FormVectors = Level[{q1, Transpose[KinFunc[Evaluate[KinVecs]]@@@ kins]}, {-1}];
  FormTensors = Level[KinFunc[Evaluate[KinTens]]@@@ kins, {-1}];
  Block[ {Set},
    (FormExec[cmd_] := Block[#, ReadForm[cmd, $ReadFormDebug]])& @
      Flatten[{Set@@@ FromFormRules, Dot = pJ, pow = Power, NoExpand = Plus}]
  ];

  Attributes[dot] = {Orderless, Listable};

  kikj = dot[Moms, Moms];
  If[ onshell, kikj = MapThread[Set, {kikj, masses}] ];

  Switch[ Length[kins],
    0 | 1,
      Null,
    2,
      Moms[[2]] = Moms[[1]],
    _,
      If[ inv,
        invs = Flatten[Array[Inv[Range[# - 1], #]&, legs - 2, 2]];
        Scan[(RealQ[#] = True)&, invs];
        InvSum = kikj[[-1]] + Plus@@ ((legs - 3) Drop[kikj, -1]);

	(* The number of invariants is ninv = (legs - 1)(legs - 2)/2 in
	   total and ndot = (legs - 2) in a dot product (of the terms in
	   pi.plegs = Sum[pi.pj, {j, legs - 1}], pi.pi is a mass^2).
	   Thus, the number of invariants in pi.plegs can be reduced by
	   using the Mandelstam relation only if ndot > ninv/2, that is
	   legs < 5.  The case legs = 3 is handled specially already by
	   Inv, so only legs = 4 remains. *)
        OtherProd[ Moms, signs,
          If[legs === 4, Distribute[(Plus@@ invs - InvSum)/2], 0] ];

        If[ invsimp && onshell && legs =!= 3,
          n = Length[invs] + 1;
          invproc = ToForm[MapIndexed[
            {"id `foo'(FC?) = `foo'(FC, replace_(",
              #1, ", ",  InvSum - Plus@@ Drop[invs, #2],
              ")*FC);\n#call Fewest(`foo')\n"}&, invs ]]
        ];

	  (* not used anywhere in FormCalc, but useful for debugging: *)
        InvSum = Plus@@ invs - InvSum
      ];

      n = signs Moms;
      MomSum = Plus@@ n;
      FormProcs = {FormProcs, "#define MomSum \"", ToForm[MomSum], "\"\n"};
      If[ momsimp, FormProcs = {FormProcs, ToForm[
        {"#define ", Moms[[#]], " \"", -signs[[#]] Plus@@ Drop[n, {#}], "\"\n"}&/@
          If[transv || onshell || inv, Range[legs], {legs}] ] }
      ]
  ];

  kikj = ReleaseHold[DownValues[dot] /. dot -> Dot];

  If[ transv, eiki = KinFunc[{e.k -> 0, ec.k -> 0}]@@@ kins ];

  If[ norm, eiei = KinFunc[e.ec -> -1]@@@ kins ];

  FormProcs = FormProcs <> "\
#define Legs \"" <> ToString[legs] <> "\"\n\
#define Scale \"" <> ToForm[scale] <> "\"\n\n\
#procedure Neglect\n" <> FormId[neglect] <> "#endprocedure\n\n\
#procedure Square\n\
repeat id pow(FC?, FC1?) * pow(FC?, FC2?) = pow(FC, FC1 + FC2);\n\
id pow(FC?, FC1?int_) = FC^FC1;\n" <>
    FormSq[square] <> "#endprocedure\n\n\
#procedure eiei\n" <> FormId[eiei] <> "#endprocedure\n\n\
#procedure eiki\n" <> FormId[eiki] <> "#endprocedure\n\n\
#procedure kikj\n" <> FormId[kikj] <> "#endprocedure\n\n\
#procedure InvSimplify(foo)\n" <> invproc <> "#endprocedure\n\n";

	(* not used anywhere in FormCalc, but useful for debugging: *)
  PairRules = Flatten[{eiei, eiki, kikj}] /. Dot -> Pair /. FromFormRules;

  FormSymbols = {Last/@ kikj, neglect, square, scale, pow[]};

] /; proc =!= CurrentProcess || scale =!= CurrentScale || flags =!= CurrentFlags


LevelSelect[Generic][id_, _, gen_, ___] :=
Block[ {name = AmpName[Select[id, FreeQ[#, Classes | Particles | Number]&]]},
  {name -> gen /. { g:G[_][_][__][__] :> coup[g],
                    m_Mass :> mass[m],
                    x_GaugeXi :> xi[x],
                    v:VertexFunction[_][__] :> vf[v] }, name, {}, {}}
]

LevelSelect[level_][id_, _, gen_, gm_ -> ins_] :=
Block[ {old, new, amp, name = AmpName[id], pc},
  _pc = 0;
  old = TrivialSums/@ Cases[{ins}, Insertions[level][r__] :> r, Infinity];
  new = Thread[Flatten[ReduceIns[gm, Transpose[old]]], Rule];
  amp = gen /. new[[1]] /.
    {p_PropagatorDenominator :> (p /. small[m_] -> m), _small -> 0};
  If[ new[[2]] === {},
    {name -> amp, Length[old] name, {}, {}},
  (* else *)
    new = Thread[new[[2]], Rule];
    {{}, {}, name@@ new[[1]] -> amp,
      "i" <> name -> Plus@@ MapThread[ name, new[[2]] ]}
  ]
]

LevelSelect[_][id_, _, amp_] :=
Block[ {name = AmpName[Select[id, FreeQ[#, Number]&]]},
  {name -> TrivialSums[amp], name, {}, {}}
]


ReduceIns[{g_, rg___},
  {{ins_ /; (* LeafCount[ins] < 10 && *)
		(* Commuting functions in FORM are only commuting in
		   nonnegative powers.  The following FreeQ makes sure
		   that all expressions containing such are always
		   inserted *after* the kinematical simplification so
		   that FORM won't screw up the spinor chains. *)
            FreeQ[ins, _[__]^_?Negative], r___} /; ins === r, rins___}] :=
Block[ {smallg},
  smallg = If[ Neglect[ins] === 0, small[ins], ins ];
  { (g -> smallg) -> Sequence[], ReduceIns[{rg}, {rins}] }
]

ReduceIns[{g_, rg___}, {ins_List, rins___}] :=
Block[ {instype = InsType[g], newg, smallg},
  newg = ToSymbol[
    If[ FreeQ[ins, DenyHide], "Form`p", "FormCalc`c" ],
    instype, ++pc[instype] ];
  smallg = If[ Union[Neglect/@ ins] === {0}, small[newg], newg ];
  { (g -> smallg) -> (newg -> inssym/@ ins),
    ReduceIns[{rg}, Replace[{rins}, {ins -> smallg, -ins -> -smallg}, 1]] }
]

ReduceIns[{g_, rg___}, {newg_, rins___}] :=
  { (g -> newg) -> Sequence[], ReduceIns[{rg}, {rins}] }

ReduceIns[{}, {}] = {}


InsType[_Mass] = "M"

InsType[RelativeCF] = "R"

InsType[_GaugeXi] = "X"

InsType[_] = "G"


AmpName[g_] :=
Block[ {t, c},
  t = StringJoin@@ ({StringTake[ToString[#1], 1], ToString[#2]}&)@@@ g;
  If[ (c = ++uniq[t]) === 1, t, t <> "v" <> ToString[c] ]
]


TrivialSums[ins_ -> _] := TrivialSums[ins]

TrivialSums[ins_] := ins /; FreeQ[ins, SumOver]

TrivialSums[ins_] :=
Block[ {test = ins /. _SumOver -> 1},
  ins /. SumOver -> CarryOut
]

CarryOut[i_, n_, r___] := (
  ranges = {i -> i == n, ranges};
  sumover[i, n, r]
) /; !FreeQ[test, i]

CarryOut[_, v_, External] := Sqrt[v]

CarryOut[_, v_, ___] = v


Attributes[OffShell] = {Listable}

OffShell[fal:FeynAmpList[__][___].., extmass__Rule] :=
Block[ {subst},
  (subst[#1][_] = #2)&@@@ {extmass};
  subst[_][m_] = m;
  ##&@@ ({fal} /. (Process -> p_) :>
    Block[{c = 0}, Process -> Map[MapAt[subst[++c], #, 3]&, p, {2}]])
]


Combine::incomp = "Warning: combining incompatible processes."

Combine[fal:FeynAmpList[__][___]..] :=
Block[ {amps = {fal}},
  If[ !SameQ@@ Cases[Head/@ amps, _[Process, p_] -> p, {2}],
    Message[Combine::incomp] ];
  Level[ amps, {1}, amps[[1, 0]] ]
]

Combine[amp:Amp[_][___]..] :=
Block[ {amps = {amp}, comp},
  If[ !Level[Head/@ amps, {1}, SameQ],
    Message[Combine::incomp] ];
  _comp = 0;
  Map[Component, amps, {2}];
  _comp =.;
  amps[[1, 0]]@@ Cases[DownValues[comp], _[_[_[x__]], r_] -> r x]
]

Component[r_ s__SumOver] := comp[s] += r

Component[other_] := comp[] += other


m_MultiplyDiagrams[fal:FeynAmpList[__][___]] := m/@ fal

MultiplyDiagrams[f_][FeynAmp[id_, q_, gen_, gm_ -> ins_]] :=
  FeynAmp[id, q, gen, gm -> MultiplyIns[f, gen, gm]/@ ins]

MultiplyDiagrams[f_][FeynAmp[id_, q_, amp_]] :=
  FeynAmp[id, q, f[amp] amp]

i_MultiplyIns[ins_ -> more_] := i[ins] -> i/@ more

MultiplyIns[f_, gen_, gm_][{r__, fac_}] := {r, f[gen, gm -> {r, fac}] fac}


TagDiagrams[diags_] :=
Block[ {diag = 0},
  MultiplyDiagrams[Diagram[++diag]&][diags]
]


(* the main function CalcFeynAmp *)

SUNObjs = SUNSum | SUNT | SUNTSum | SUNF | SUNEps

DenyNoExp = Level[{ga, Spinor, Den, A0i, B0i, C0i, D0i, E0i, F0i,
  SumOver, SUNObjs}, {-1}]

DenyHide = Level[{SumOver, IndexDelta, IndexEps, SUNObjs},
  {-1}, Alternatives]

AfterSelect[ins_] := {ins, {}} /;
  LeafCount[ins] > 30 && FreeQ[ins, DenyHide]

AfterSelect[other_] := {{}, other}

FinalFormRules = {
  x_^r_Rational -> pow[x, r],
  Complex[a_, b_] -> a + "i_" b }


Attributes[CalcFeynAmp] = {Listable}

Options[CalcFeynAmp] = {
  CalcLevel -> Automatic,
  Dimension -> D,
  OnShell -> True,
  Invariants -> True,
  Transverse -> True,
  Normalized -> True,
  MomSimplify -> True,
  InvSimplify -> True,
  FermionChains -> Weyl,
  FermionOrder -> Automatic,
  InsertAt -> Default,
  CutTools -> False,
  NoExpand -> {},
  AbbrScale -> 1,
  EditCode -> False,
  RetainFile -> False }

CalcFeynAmp::syntax = "Wrong syntax: CalcFeynAmp expects FeynAmpList
objects as arguments."

CalcFeynAmp::incomp = "Calculation of incompatible process(es) attempted.
If you want to calculate a new process, run ClearProcess[] first."

CalcFeynAmp[fal:FeynAmpList[__][___].., opt___Rule] :=
Block[ {lev, dim, onshell, inv, transv, norm, momsimp, invsimp, fchain,
insat, cuttools, noexp, scale, edit, retain, procs, proc, uniq, vecs,
legs = 0, ic, inssym, formins, mmains, indices, ranges = {}, 
indsym, vars, patt, hh, amps, formexec, traces = False, res = 0},

  procs = Cases[Head/@ {fal}, _[Process, p_] -> p, {2}];
  indices = DeleteCases[Union@@ Cases[procs, _List, {-2}], _Integer];
  proc = Union[Apply[#3 &, procs, {3}], {CurrentProcess}];
  If[ Length[proc] =!= 1, Message[CalcFeynAmp::incomp]; Abort[] ];

  {lev, dim, onshell, inv, transv, norm, momsimp, invsimp,
    fchain, forder, insat, cuttools, noexp, scale, edit, retain} =
    ParseOpt[CalcFeynAmp, opt];
  lev = Flatten[{lev}][[-1]] /.
    Automatic :> Which[
      !FreeQ[{fal}, Particles], Particles,
      !FreeQ[{fal}, Classes], Classes,
      True, Generic ];

  DeclareProcess[ proc[[1]], scale,
    TrueQ/@ {onshell, inv, transv, norm, momsimp, invsimp} ];

(*
  NoExp[p_] := NoExp[p] = Unique["noexp"];
  NoExpandRule = (p_Plus :> NoExp[p] /; !FreeQ[p, #1] && FreeQ[p, #2])&[
    Alternatives@@ Flatten[{noexp}],
    Alternatives@@ Flatten[{FormVectors, FormTensors, DenyNoExp}] ];
*)

  NoExpandRule = (p_Plus :> (p /. Plus -> NoExpand) /;
    !FreeQ[p, #1] && FreeQ[p, #2])&[
      Alternatives@@ Flatten[{noexp}],
      Alternatives@@ Flatten[{FormVectors, FormTensors, DenyNoExp}] ];

  _ic = 0;
  inssym[x_Symbol] = x;
  inssym[ins_] := inssym[ins] =
    ToSymbol["FormCalc`i", instype, ++ic[instype]];

  _uniq = 0;
  vecs = {};
  amps = Apply[LevelSelect[lev], Level[Hold[fal], {2}] /.
      {IndexDelta -> idelta, IndexEps -> ieps} /.
      IndexSum -> isum, 1] /.
    Thread[(#2&@@@ Level[procs[[1]], {2}]) -> Moms] /.
    FourMomentum[Internal, 1] -> q1 /.
    PolarizationVector | PolarizationTensor -> pol /. {
      _MetricTensor^2 -> dim,
      MetricTensor -> "d_",
      LeviCivita -> "e_",
      ScalarProduct -> scalar,
      PropagatorDenominator -> prop,
      FeynAmpDenominator -> loop,
      (DiracSpinor | MajoranaSpinor)[pm_. p_Symbol, m_] :>
        Spinor[p, Neglect[m], pm],
      ChiralityProjector[c_] :> ga[(13 - c)/2],
      DiracMatrix -> ga,
      DiracSlash[p_] :> MomThread[p, ga],
      NonCommutative -> noncomm,
      FourVector[p_, mu_] :>
        (vecs = {vecs, Symbols[p]}; MomThread[p, #[mu]&]) };

  FormVectors = Join[FormVectors,
    Complement[Flatten[vecs], FormVectors]];

  amps = DeleteCases[amps, {___, _ -> 0, __}];
  If[ Length[amps] === 0, Return[Amp[CurrentProcess][0]] ];

  inssym[x_Symbol] =.;

  formins = Cases[DownValues[inssym], _[_[_[ins_]], s_Symbol] :> s == ins];
  If[ insat === End,
    {mmains, formins} = ToCat[2, AfterSelect/@ formins] ];

  amps = {ToCat[4, amps], formins} /. NoExpandRule /. FinalFormRules;

  indsym[type_, n_] := (
    indices = {indices, #};
    Switch[ type,
      Lorentz, ranges = {# -> #, ranges},
      EpsilonScalar, ranges = {# -> # == Dminus4, ranges} ];
    indsym[type, n] = #
  )& @ iname[type, n];

  amps = amps /. Index -> indsym;
  mmains = mmains /. Index -> indsym;
  ranges = Append[Union[Flatten[ranges]] /. Index -> indsym, i_ -> i == 0];

  indices = Union[Flatten[ {indices,
    Cases[DownValues[indsym], _[_, s_Symbol] -> s],
	(* possibly some colour or gluon indices have been fixed by
	   the user in FeynArts; these would by default be declared
	   as symbols and not be seen by FORM: *)
    Cases[amps, SUNObjs[o__] :> Cases[{o}, _Symbol], Infinity]} ]];

  vars = DeclareVars[amps, SUNN, indices, ranges];

  hh = OpenForm[];
  WriteString[hh,
    If[ dim === D,
      "s D, Dminus4;\nd D:Dminus4;\n",
      {"s Dminus4;\nd ", ToString[dim], ";\n"} ] <>
     vars[[1]] <>
    "\n.global\n\n"];

  If[ Length[ amps[[1, 1]] ] =!= 0,
    FormWrite[ hh, amps[[1, 1]] ];
    WriteString[hh, ".store\n\n"];
    res = FormWrite[ hh, FormCalc`NoIns -> Plus@@ amps[[1, 2]] ]
  ];

  patt = Select[
    Level[FormWrite[ hh, amps[[1, 3]] ], {2}]//Union,
    Context[#] === "FormCalc`" & ];

  WriteString[hh,
    If[ traces, "trace4,1;\n\n", "" ] <> "\
#define Dim \"" <> ToString[dim] <> "\"\n\
#define OnShell \"" <> ToBool[onshell] <> "\"\n\
#define InsertAt \"" <> ToForm[insat] <> "\"\n\
#define CutTools \"" <> ToBool[cuttools] <> "\"\n\
#define HaveFermions \"" <> ToBool[!FreeQ[amps, FermionChain]] <> "\"\n\
#define FermionOrder \"" <> ToSeq[forder] <> "\"\n\
#define FermionChains \"" <> ToForm[fchain] <> "\"\n\
#define HaveSUN \"" <> ToBool[!FreeQ[amps, SUNObjs]] <> "\"\n\
#define SUNN \"" <> ToForm[SUNN] <> "\"\n\
#define Patterns \"" <> ToSeq[patt] <> "\"\n" <>
    FormProcs <> "\
#procedure Const\n" <>
    FormDecl["ab ", DeleteCases[ vars[[2]],
      (x_ /; MemberQ[{"FeynArts`", "FormCalc`", "LoopTools`"}, Context[x]]) |
      SUNObjs | Conjugate, {2} ]//Flatten] <> "\
#endprocedure\n\n\
#procedure FillIns\n"];
  Scan[ Write[hh, "id ", #, ";"]&, amps[[2]] ];
  WriteString[hh, "\
#endprocedure\n\n\
#procedure Insertions\n"];
  res += Plus@@ FormWrite[ hh, amps[[1, 4]] ];
  WriteString[hh, ".store\n\n"];
  FormWrite[hh, FormCalc`Result -> res];
  WriteString[hh, "\
#endprocedure\n\n\
#include " <> ToFileName[$FormCalcProgramDir, "CalcFeynAmp.frm"] <> "\n"];
  Close[hh];

  If[ insat =!= End || Length[mmains] == 0,
    formexec = FormExec,
  (* else *)
    Block[ {Set},
      (formexec[cmd_] := Block[#, FormExec[cmd]])&[ Set@@@ mmains ] ]
  ];

  Amp[CurrentProcess]@@ RunForm[edit, retain, formexec][[1]]
]

CalcFeynAmp[___] := (Message[CalcFeynAmp::syntax]; Abort[])


(* FORM interfacing *)

chain[expr__] := (++fline; NonCommutativeMultiply[expr] /. ga -> om)

trace[expr__] := (traces = True;
  NonCommutativeMultiply[expr] /. {
    a_. ga[li_] ** ga[1] + a_. ga[li_] ** ga[-1] :> a "g_"[fline, li],
    a_. ga[1] + a_. ga[-1] :> a "g_"[fline],
    ga -> om }
)

Attributes[FormWrite] = {Listable}

FormWrite[hh_, lhs_ -> rhs_] :=
Block[ {fline = 1},
  Write[hh, "G ", lhs == (rhs /.
    MatrixTrace -> trace /. FermionChain -> chain /.
    NonCommutativeMultiply[a_] -> a), ";"];
  WriteString[hh, "\n"];
  lhs
]


FormDecl[_, _[]] = {}

FormDecl[type_, _[f_, v___]] :=
Block[ {l, ll, t},
  ll = StringLength[t = type <> ToForm[f]];
  { Fold[
      ( l = StringLength[t = ToForm[#2]] + 2;
        {#1, If[(ll += l) > 70, ll = l; ",\n  ", ", "], t} )&,
      t, {v} ],
    ";\n" }
]


Attributes[FormId] = Attributes[FormSq] = {Listable}

FormId[_[lhs_, rhs_], endl_:";\n"] :=
  {"id ", ToForm[lhs], " = ", ToForm[rhs], endl}

FormSq[_[lhs_, rhs_], endl_:";\n"] :=
  {"id ", #1, "^2 = ", #2, endl,
   "id ", #1, "^-2 = (", #2, ")^-1", endl}&[ ToForm[lhs], ToForm[rhs] ]


DeclareVars[expr__, indices_, ranges_] :=
Block[ {theexpr, vars, cfunc, func},
  theexpr = {expr, FormSymbols};

  vars = Complement[Symbols[theexpr],
    indices, FormVectors, FormTensors, {D}];

  cfunc = Complement[Cases[Head/@ Level[theexpr, {2, -2}], _Symbol],
    FormVectors, FormTensors, ExtWF,
    {ga, MatrixTrace, FermionChain, NonCommutativeMultiply,
     List, Rule, Equal, Plus, Times, Power, Dot, Rational}];

  func = Intersection[cfunc, {Spinor, DottedSpinor}];
  cfunc = Complement[cfunc, func];

  { { FormDecl["i ", Replace[indices, ranges, 1]],
      FormDecl["s ", vars],
      FormDecl["cf ", cfunc],
      FormDecl["f ", func],
      FormDecl["v ", FormVectors],
      FormDecl["t ", FormTensors] },
    {vars, cfunc} }
]


toform = "!" <> ToFileName[{$FormCalcDir, $SystemID}, "ToForm"] <> " > "

tempnum = 1

OpenForm[] :=
Block[ {hh},
  While[
    tempfile = $TemporaryPrefix <> ToString[tempnum] <> ".frm";
    FileType[tempfile] =!= None, ++tempnum ];
  Print[""];
  Print["preparing FORM code in ", tempfile];
  hh = OpenWrite[toform <> tempfile,
    FormatType -> InputForm, PageWidth -> 73];
  WriteString[hh, FormSetup];
  hh
]

RunForm[edit_, retain_, exec_:FormExec] :=
Block[ {res},
  If[ edit, Pause[1]; Run[StringForm[$Editor, tempfile]]; Pause[3] ];
  WriteString["stdout", "running FORM... "];
  If[ Check[res = exec["!" <> $FormCmd <> " " <> tempfile]; True, False] &&
    !retain, DeleteFile[tempfile] ];
  Print["ok"];
  res
]


(* things to do when the amplitude comes back from FORM *)

dJ = MetricTensor

iJ = I

_dummyJ = 1

cuti[h_[n_], args__] := h[num[Num[n]], args]

pave[A0i[0], args__] := A0[args];
pave[A0i[0, 0], args__] := A00[args];
pave[h_[i__], args__] := h[paveid[h, i], args]

paveid[h_, i__] := paveid[h, i] =
Block[ {t = ToLowerCase[StringTake[ToString[h], 1]]},
  ToSymbol["LoopTools`", t, t, i]
]

A0[0] = 0

B0i[id:bb0 | dbb0, p_, m1_, m2_] :=
  B0i[id, p, m2, m1] /; !OrderedQ[{m1, m2}]

MapThread[
  (Derivative[0, 1, 0, 0][B0i][#1, args__] := B0i[#2, args])&,
  {{bb0, bb1, bb00, bb11}, {dbb0, dbb1, dbb00, dbb11}} ]


(* abbreviationing business *)

Mat[0] = 0

DiracChain[sp___Spinor, 1, r___] := DiracChain[sp, r]

fme[x_] := ferm[x, CurrentScale]

ferm[x__] := ferm[x] = Unique["F"]


sun[x_] := sun[x] = Unique["SUN"]


pJ[a_, x_^n_] := pJ[a, x]^n
	(* different operator priority in FORM *)

pJ[x__] := pair[Pair[x], CurrentScale]

pair[x__] := pair[x] = Unique["Pair"]


eJ[x__] := eps[Eps[x], CurrentScale]

eps[x__] := eps[x] = Unique["Eps"]


num[x_] := num[x] = Unique["Num"]


abb[p_Plus] := abbsum[abb/@ p]

abb[n_?NumberQ x_] := n abb[x]

abb[x_?AtomQ] = x

abb[x_] := abb[x] = Unique["Abb"]

abbsum[x_] := abbsum[x] = Unique["AbbSum"]


Attributes[dv] = {HoldAll}

dv[x_, _] := {} /; !FreeQ[x, Pattern]

dv[_[_[x_]], s_Symbol] := s -> x

dv[_[_[x_, 1]], s_Symbol] := s -> x

dv[_[_[x_, scale_]], s_Symbol] := s -> x/scale^(Count[4711 x, _k, {2}]/2)


Abbr[] := Flatten @
  Apply[dv, DownValues/@ {ferm, sun, pair, eps, num, abb, abbsum}, {2}]

Abbr[patt__] :=
Block[ {all = Abbr[], need = Flatten[{patt}], omit},
  omit = Cases[need, !x_ -> x];
  need = DeleteCases[need, !_];
  FixedPoint[ abbsel[First/@ #]&, abbsel[need, omit] ]
]

abbsel[{need__}, {omit__}] := Select[all,
  !FreeQ[#, Alternatives[need]] && FreeQ[#, Alternatives[omit]]&]

abbsel[{need__}, ___] := Select[all, !FreeQ[#, Alternatives[need]]&]


coup[g_] := coup[g] = Unique["Coupling"]

mass[m_] := mass[m] = Unique["Mass"]

xi[x_] := xi[x] = Unique["GaugeXi"]

vf[v_] := vf[v] = Unique["VertexFunction"]


GenericList[] := Flatten @
  Apply[dv, DownValues/@ {coup, mass, xi, vertex}, {2}]


ClearProcess[] := (
  CurrentProcess = Sequence[];
  ClearCache[];
  Apply[zap, DownValues/@ {ferm, sun, pair, eps, num, abb, abbsum,
    coup, mass, xi, vertex}, {2}]; )

Attributes[zap] = {HoldAll}

zap[p_, s_Symbol] := (Unset@@ p; Remove[s]) /; FreeQ[p, Pattern]

zap[p_, s_Symbol[__]] := (Unset@@ p; Remove[s]) /; FreeQ[p, Pattern]


DenyFunc[leaf_, _[]] := LeafCount[#] < leaf &

DenyFunc[leaf_, deny_] := LeafCount[#] < leaf || !FreeQ[#, deny] &


Options[Abbreviate] = {
  MinLeafCount -> 10,
  Deny -> {},
  Preprocess -> Identity }

Abbreviate[expr_, level_Integer:2, opt___Rule] :=
Block[ {minleaf, deny, pre, abbprep, sums, ind, pos},
  {minleaf, deny, pre} = ParseOpt[Abbreviate, opt];
  deny = DenyFunc[minleaf, Alternatives@@ Flatten[{deny}]];

  If[ pre === Identity,
    abbprep = abbplus,
  (* else *)
    ( abbprep[i___][args__] :=
        #[Plus[args]] /. Plus -> abbplus[i] )&[ pre ] ];

  sums = Position[expr, SumOver];
  If[ Length[sums] === 0,
    Replace[expr, Plus -> abbprep[], {level, Infinity}, Heads -> True],
  (* else *)
    ind[{0}] = {};
    ind[{r___, _, 0}] := {ind[{r, 0}],
      Extract[expr, Cases[sums, {r, i_, 0} -> {r, i, 1}]]};
    pos = Position[expr, Plus, {level, Infinity}, Heads -> True];
    ReplacePart[expr, (abbprep@@ Union[ind[#]//Flatten])&/@ pos,
      pos, Array[List, Length[pos]]]
  ]
]

abbplus[___][args__] := Plus[args] /; deny[{args}]

abbplus[i___][x:(_Integer | _Rational)?Negative _., r__] :=
  -FromPlus[abbplus[i], -(x + r)]

abbplus[i___][a_^2, -b_^2] := abbplus[i][a, -b] abbplus[i][a, b]

abbplus[i___][args__] := (abbsub@@ Select[{i}, !FreeQ[{args}, #]&])[args]

abbsub[][args__] := abbsub[][args] = Unique[$SubPrefix]

abbsub[i__][args__] := abbsub[i][args] = Unique[$SubPrefix][i]

$SubPrefix = "Sub"


Subexpr[] := Cases[ SubValues[abbsub],
  _[_[_[t__]], x_] :> (x -> Plus[t]) /; FreeQ[{t}, Pattern] ]


ClearSubexpr[] := (zap@@@ SubValues[abbsub];)


RegisterSubexpr[li_] := Flatten[regsub[li]]


Attributes[regsub] = {Listable}

regsub[x_Symbol[i__] -> (h:Plus)[args__]] := (abbsub[i][args] = x; {})

regsub[x_Symbol[i__] -> other_] := (abbsub[i][other] = x; {})

regsub[x_Symbol -> (h:Plus)[args__]] := (abbsub[][args] = x; {})

regsub[x_Symbol -> other_] := (abbsub[][other] = x; {})

regsub[other_] = other


$OptPrefix = "Opt"

newvar[] := Unique[$OptPrefix]

newvar[i__] := Unique[$OptPrefix][i]


Attributes[set] = {Flat, Orderless}


ptdef[0][x_, t_] := lotdef[x, lot@@ t]

ptdef[1][x_, p_] := (lotdef[-x, FromPlus[lot, -p]]; lotdef[x, lot@@ p])

lotdef[x_, l_lot] := (l = x; {})

lotdef[x_, _Integer x_] := x -> 0

lotdef[x_, other_] := x -> other


lotget[_, _Times] := {{}, {}}

lotget[_[_[terms__]], x_] := {x, set[terms]}


Attributes[ptcom] = {Listable}

ptcom[a_set, b_set, 0] := Intersection[a, b]

ptcom[a_set, b_set, 1] := 
Block[ {cp, cm},
  cp = Intersection[a, b];
  If[ Length[a] > 2 Length[cp],
    cm = Intersection[a, Thread[-b, set]];
    If[ Length[cm] > Length[cp], cp = cm ] ];
  cp
]

_ptcom = set[]


ptrul[a_, b_, 0] := a -> b

ptrul[a_, b_, 1] := {a -> b, Thread[-a, set] -> -b}


Overlap[] = set[]

Overlap[x__] := Intersection[x]


CSE[_, {}] = {}

CSE[pt_, abbr_] :=
Block[ {lot, alias, var, def, com, tmp, new = {}},
  Attributes[lot] = {Flat, Orderless};
  alias = Flatten[ ptdef[pt]@@@
    Sort[abbr, Length[ #1[[2]] ] <= Length[ #2[[2]] ] &] ];
  {var, def} = ToCat[2, Apply[lotget, DownValues[lot], 1]];
  def = def /. alias;

  Do[
    While[ Length[com = ptcom[def[[i]], def[[i + 1]], pt]] > 3,
      tmp = Ceiling[Length[com]/2];
      tmp = Overlap@@ Select[
        ptcom[com, Drop[def, {i, i + 1}], pt],
        Length[#] > tmp & ];
      If[ Length[tmp] > 3, com = tmp ];
      tmp = Position[def, com, 1, 1, Heads -> False];
      If[ Length[tmp] > 0,
        tmp = tmp[[1, 1]];
        def[[tmp, 0]] = List;
        def = def /. ptrul[com, var[[tmp]], pt];
        def[[tmp, 0]] = set,
      (* else *)
        tmp = newvar@@ Select[
          Union[Level[{var[[i]], var[[i + 1]]}, {2}]],
          !FreeQ[com, #]& ];
        new = {new, tmp -> com};
        def = def /. ptrul[com, tmp, pt] ]
    ],
  {i, Length[def] - 1}];

  Flatten[{new, Thread[var -> def], alias}]
]


AbbrCat[rul:_[_, _Plus]] := {{}, {}, rul}

AbbrCat[rul:_[_, t_Times]] := {{}, rul, {}} /; FreeQ[t, DiracChain]

AbbrCat[rul_] := {rul, {}, {}}


OptimizeAbbr[{}] = {}

OptimizeAbbr[rul:{__Rule}] := Flatten[
  {#1, CSE[0, #2] /. set -> Times, CSE[1, #3] /. set -> Plus}&@@
    ToCat[3, AbbrCat/@ rul] ]


Attributes[simple] = {Listable}

simple[r:(_ -> _?NumberQ)] := subst[r] = Sequence[]

simple[r:(_ -> n_. _Symbol)] := (subst[r] = Sequence[]) /; NumberQ[n]

simple[other_] = other
  
SubstSimpleAbbr[args__] :=
Block[ {subst, new},
  new = simple[{args}];
  new /. (#[[1,1,1]]&)/@ DownValues[subst]
]


(* UV and IR finiteness checks *)

loopint = A0 | A00 | B0 | B1 | B00 | B11 | B001 | B111 |
  DB0 | DB1 | DB00 | DB11 | B0i | C0i | D0i | E0i | F0i

cutint = Acut | Bcut | Ccut | Dcut | Ecut | Fcut

allint = Join[loopint, cutint]

ToNewBRules = {
  B0[args__] -> B0i[bb0, args],
  B1[args__] -> B0i[bb1, args],
  B00[args__] -> B0i[bb00, args],
  B11[args__] -> B0i[bb11, args],
  B001[args__] -> B0i[bb001, args],
  B111[args__] -> B0i[bb111, args],
  DB0[args__] -> B0i[dbb0, args],
  DB1[args__] -> B0i[dbb1, args],
  DB00[args__] -> B0i[dbb00, args],
  DB11[args__] -> B0i[dbb11, args],
  C0[args__] -> C0i[cc0, args],
  D0[args__] -> D0i[dd0, args],
  E0[args__] -> E0i[ee0, args],
  F0[args__] -> F0i[ff0, args] }

ToOldBRules = {
  B0i[bb0, args__] -> B0[args],
  B0i[bb1, args__] -> B1[args],
  B0i[bb00, args__] -> B00[args],
  B0i[bb11, args__] -> B11[args],
  B0i[bb001, args__] -> B001[args],
  B0i[bb111, args__] -> B111[args],
  B0i[dbb0, args__] -> DB0[args],
  B0i[dbb1, args__] -> DB1[args],
  B0i[dbb00, args__] -> DB00[args],
  B0i[dbb11, args__] -> DB11[args] }


Attributes[DivTerms] = {Listable}

DivTerms[rc_ -> x_] := rc -> DivTerms[x]

DivTerms[IndexIf[cond_, a_, b_]] :=
  IndexIf[cond, DivTerms[a], DivTerms[b]]

DivTerms[a:Amp[_][__]] := DivTerms/@ a

DivTerms[p_Plus] := DivTerms/@ p

DivTerms[x_. Divergence] := x Divergence

DivTerms[x_ r_] := x DivTerms[r] /; FreeQ[x, Divergence]

DivTerms[x_] := x - (x /. Divergence -> 0)


UVDivergentPart[expr_] := DivTerms[expr /. ToNewBRules /.
  int:loopint[__] :> UVDiv[int]]


UVDiv[A0[m_]] = m Divergence

UVDiv[A00[m_]] = m^2/4 Divergence

UVDiv[B0i[bb0, __]] = Divergence

UVDiv[B0i[bb1, __]] = -1/2 Divergence

UVDiv[B0i[bb00, p_, m1_, m2_]] := -(p - 3 m1 - 3 m2)/12 Divergence

UVDiv[B0i[bb11, __]] = 1/3 Divergence

UVDiv[B0i[bb001, p_, m1_, m2_]] := (p - 2 m1 - 4 m2)/24 Divergence

UVDiv[B0i[bb111, __]] = -1/4 Divergence

UVDiv[B0i[dbb00, __]] = -1/12 Divergence

UVDiv[C0i[cc00, __]] = 1/4 Divergence

UVDiv[C0i[cc001 | cc002, __]] = -1/12 Divergence

UVDiv[C0i[cc0000, p1_, p2_, p1p2_, m1_, m2_, m3_]] :=
  -(p1 + p2 + p1p2 - 4 (m1 + m2 + m3))/96 Divergence

UVDiv[C0i[cc0011 | cc0022, __]] = 1/24 Divergence

UVDiv[C0i[cc0012, __]] = 1/48 Divergence

UVDiv[D0i[dd0000, __]] = 1/24 Divergence

UVDiv[D0i[dd00001 | dd00002 | dd00003, __]] = -1/96 Divergence

_UVDiv = 0


(* FeynCalc compatibility functions *)

PaVe[i__Integer, {p__}, {m__}] :=
  ToExpression[#1 <> "0i"][ ToSymbol[#2, #2, Sort[{i}]], p, m ]&[
    FromCharacterCode[Length[{m}] + 64],
    FromCharacterCode[Length[{m}] + 96] ]


FeynCalcGet[mask___] :=
Block[ {Global`OneLoopResult, Global`GraphName},
  _Global`GraphName = 0;
  Plus@@ ((Get[#]; Global`OneLoopResult[0])&)/@
    FileNames[mask] /. ep_Eps :> I ep
]


FeynCalcPut[expr_, file_] :=
Block[ {C0i, D0i, E0i, F0i, PaVe},
  C0i[cc0, args___] := C0[args];
  D0i[dd0, args___] := D0[args];
  E0i[ee0, args___] := E0[args];
  F0i[ee0, args___] := F0[args];
  C0i[i_, p__, m1_, m2_, m3_] := PaVe[
    Sequence@@ (ToExpression/@ Drop[Characters[ToString[i]], 2]),
    {p}, {m1, m2, m3} ];
  D0i[i_, p__, m1_, m2_, m3_, m4_] := PaVe[
    Sequence@@ (ToExpression/@ Drop[Characters[ToString[i]], 2]),
    {p}, {m1, m2, m3, m4} ];
  E0i[i_, p__, m1_, m2_, m3_, m4_, m5_] := PaVe[
    Sequence@@ (ToExpression/@ Drop[Characters[ToString[i]], 2]),
    {p}, {m1, m2, m3, m4, m5} ];
  F0i[i_, p__, m1_, m2_, m3_, m4_, m5_, m6_] := PaVe[
    Sequence@@ (ToExpression/@ Drop[Characters[ToString[i]], 2]),
    {p}, {m1, m2, m3, m4, m5, m6} ];
  Put[expr /. ToOldBRules, file]
]


(* helicity matrix elements *)

om[1] := "g_"[fline]

om[5] := "g5_"[fline]

om[6] := "g6_"[fline]/2

om[7] := "g7_"[fline]/2

om[Sigma[mu_, nu_]] := ("g_"[fline, mu, nu] - "g_"[fline, nu, mu])/2

om[rho[k[n_], 0, pm_]] :=
  ("g_"[fline] + pm Hel[n] "g5_"[fline]) ** "g_"[fline, k[n]]/2

om[rho[k[n_], m_, pm_]] :=
  ("g_"[fline] + Hel[n] "g5_"[fline] ** "g_"[fline, e[n]]) **
    ("g_"[fline, k[n]] + pm m "g_"[fline])/2

om[rhoc[k[n_], 0, pm_]] :=
  -"g_"[fline, k[n]] ** ("g_"[fline] + pm Hel[n] "g5_"[fline])/2

om[rhoc[k[n_], m_, pm_]] :=
  (-"g_"[fline, k[n]] + pm m "g_"[fline]) **
    ("g_"[fline] - Hel[n] "g_"[fline, e[n]] ** "g5_"[fline])/2

om[li___] := "g_"[fline, li]


ToTrace[fi_ -> plain_, fj_ -> conj_] :=
Block[ {me, fline = 0},
  me = plain conj //. {
    DiracChain[a___, Spinor[k_, m_, pm_]] DiracChain[Spinor[k_, __], b___] :>
      DiracChain[a, rho[k, Neglect[m], pm], b],
	(* If the spinors at the ends don't match directly, we
	   have to reverse one chain.  This is a charge conjugation,
	   not a hermitian conjugation like the one HelicityME
	   does for the "conj" part.  The rules:
	     a) reverse the chain and exchange u <-> v,
	     b) gamma_mu -> -gamma_mu,
	     c) add a global minus sign to compensate for the
	        change in the permutation of the external fermions.
	   For details see the Denner/Eck/Hahn/Kueblbeck paper. *)
    DiracChain[Spinor[k1_, __], a___, Spinor[k2_, m2_, pm2_]] *
      DiracChain[Spinor[k1_, m1_, pm1_], b___] :>
      -(-1)^Count[{a}, _String | _[_]] DiracChain[
        Spinor[k2, m2, -pm2],
        Sequence@@ Reverse[{a} /. {rho -> rhoc, rhoc -> rho}],
        rho[k1, Neglect[m1], pm1], b ]
  } /.
    DiracChain[Spinor[k_, m_, pm_], a___, Spinor[k_, __]] :>
      (++fline; om/@ (rho[k, Neglect[m], pm] ** a));
  Mat[fi, fj] -> {fline, me}
]


ToHel[k[n_], __] := {{}, {}} /; Head[Hel[n]] =!= Hel

ToHel[k[n_], 0, pm_] :=
Block[ {h = Heli[n]},
  {Hel[n] -> h - pm, h -> Hel[n] + pm}
]

ToHel[k_, __] := ToHel[k, 0, 0]


Heli[n_] := Heli[n] = ToSymbol["Hel", n]


SelectArg[All] := fabbr

SelectArg[expr_] := Union[Select[fabbr, !FreeQ[ expr, #[[1]] ]&]]


uv[1] = "u"

uv[-1] = "v"

Format[DiracChain[Spinor[p1_, m1_, pm1_], c___, Spinor[p2_, m2_, pm2_]]] :=
  DiracChain[Overscript[uv[pm1], "_"][p1, m1], c, uv[pm2][p2, m2]]


ConjChain[sp___Spinor, 5, g___] := -rev[sp, 5, g]

ConjChain[sp___Spinor, 6, g___] := rev[sp, 7, g]

ConjChain[sp___Spinor, 7, g___] := rev[sp, 6, g]

ConjChain[g__] := rev[g]

rev[g__] := ((-1)^Count[#, _Sigma] Reverse[#])&[ DiracChain[g] ]


Options[HelicityME] = {
  Source :> Abbr[],
  EditCode -> False,
  RetainFile -> False }

HelicityME::noprocess =
"No process defined so far.  HelicityME works only after CalcFeynAmp."

HelicityME::weyl =
"Warning: HelicityME does not work on WeylChains.  CalcFeynAmp uses
DiracChains with the option FermionChains -> Chiral or VA."

HelicityME::nomat = "Warning: No matrix elements to compute."

HelicityME[plain_, opt___?OptionQ] := HelicityME[plain, plain, opt]

HelicityME[plain_, conj_, opt___?OptionQ] :=
Block[ {abbr, edit, retain,
fabbr, part, tohel, fromhel, hels,
ind, c = 0, vars, hh, e, traces},

  If[ {CurrentProcess} === {},
    Message[HelicityME::noprocess];
    Abort[] ];

  {abbr, edit, retain} = ParseOpt[HelicityME, opt];

  If[ !FreeQ[abbr, WeylChain], Message[HelicityME::weyl] ];

  fabbr = Select[abbr, !FreeQ[#, DiracChain[_Spinor, ___]]&];
  abbr = SelectArg/@ {plain, conj};
  If[ Times@@ Length/@ abbr === 0,
    Message[HelicityME::nomat];
    Return[{}] ];

  part = Cases[abbr, _Spinor, Infinity]//Union;
  {tohel, fromhel} = ToCat[2, ToHel@@@ part];
  part = #[[1, 1]]&/@ part;
  hels = First/@ fromhel;

  ind = Map[# -> "N" <> ToString[++c] <> "_?" &,
    Union[Cases[#, _Lor, Infinity]]&/@ abbr, {2}];

  traces = Flatten[Outer[ ToTrace, abbr[[1]] /. ind[[1]],
    abbr[[2]] /. ind[[2]] /. DiracChain -> ConjChain /.
      ep_Eps -> -ep /. ConjWF ]] /.
    tohel /. Reverse/@ FromFormRules /. Eps -> "e_" /.
    FinalFormRules;

  Print["> ", Length[traces], " helicity matrix elements"];

  vars = DeclareVars[Last/@ traces, hels, {}, {}];

  hh = OpenForm[];
  WriteString[hh,
    vars[[1]] <> "\n\
#define Hels \"" <> ToSeq[hels] <> "\"\n" <>
    FormProcs <> "\
#include " <> ToFileName[$FormCalcProgramDir, "HelicityME.frm"] <> "\n\n"];

  ( Write[hh, "L " <> "Mat" <> ToString/@ List@@ #1 <> " = ",
      #2[[2]], ";"];
    Array[ WriteString[hh, "\ntrace4,", #, ";"]&, #2[[1]] ];
    WriteString[hh, "\n#call Emit\n\n"]
  )&@@@ traces;

  WriteString[hh, ".end\n"];
  Close[hh];

  (e[#] = s[#])&/@ part;

  Thread[First/@ traces -> Plus@@@ RunForm[edit, retain]] /. fromhel
]


(* colour matrix elements *)

sunT[i_Symbol, i_] := SUNN

sunT[_, i_Symbol, i_] = 0

sunT[a_Integer, a_, i_Symbol, i_] = 1/2

sunT[_Integer, _Integer, i_Symbol, i_] = 0

sunT[t1___, a_Symbol, t2___, a_, t3___, i_, j_] :=
  (sunT[t1, t3, i, j] sunTr[t2] -
    sunT[t1, t2, t3, i, j]/SUNN)/2

sunT[t1___, a_Symbol, t2___, i_, j_] sunT[t3___, a_, t4___, k_, l_] ^:=
  (sunT[t1, t4, i, l] sunT[t3, t2, k, j] -
    sunT[t1, t2, i, j] sunT[t3, t4, k, l]/SUNN)/2

sunT[a___, i_, j_Symbol] sunT[b___, j_, k_] ^:=
  sunT[a, b, i, k]

sunT[a___, i_, j_Symbol] sunT[b___, k_, j_] ^:=
  Level[{{a}, Reverse[{b}], {i, k}}, {2}, sunT]

sunT[a___, j_Symbol, i_] sunT[b___, j_, k_] ^:=
  Level[{Reverse[{a}], {b}, {i, k}}, {2}, sunT]

sunT/: sunT[a___, i_, j_Symbol]^2 :=
  Level[{{a}, Reverse[{a}], {i, i}}, {2}, sunT]

sunT/: sunT[a___, i_Symbol, j_]^2 :=
  Level[{Reverse[{a}], {a, j, j}}, {2}, sunT]


sunTr[] := SUNN

sunTr[_] = 0

sunTr[a__] := sunT[a, #, #]& @ Unique["col"]


(* we assume that structures of the form delta[a, a] indicate
   summations over external colour/gluon indices *)

sunText[i_Symbol, i_] := Sqrt[SUNN]

sunText[a_Symbol, a_, 0, 0] := Sqrt[SUNN^2 - 1]/2

sunText[a___, 0, 0] := sunTrace[a]

sunText[other__] := sunT[other]


sunF[a_, b_, c_] := 2 I (sunTrace[c, b, a] - sunTrace[a, b, c])

sunF[a__, b_, c_] := (sunF[a, #] sunF[#, b, c])& @ Unique["glu"]


sunEps/: sunEps[a___, _Symbol, b___]^2 :=
  (sunT[#1, #1] sunT[#2, #2] - sunT[#1, #2]^2)&[a, b]

sunEps[a___, i_Symbol, b___] sunEps[c___, i_, d___] ^:=
  (-1)^Length[{a, c}] *
  ((sunT[#1, #3] sunT[#2, #4] -
    sunT[#1, #2] sunT[#3, #4])&[a, b, c, d])


Conjugate[t_SUNT] ^:= RotateLeft[Reverse[t], 2]

Conjugate[f_SUNF] ^= f


ColourSimplify[plain_, conj_:1] :=
Block[ {res, ind},
  {res, ind} = Reap[ plain Conjugate[conj] /.
    {IndexDelta -> idelta, SumOver -> sumover} /.
    SUNSum[i_, _] :> (Sow[i]; 1) ];
  Simplify[ Expand[ res /.
    Cases[ind, i_Index :> i -> iname@@ i, {2}] /.
    {SUNT -> sunText, SUNF -> sunF, SUNEps -> sunEps} /.
    sunTrace[a__]^n_. :> Times@@ Table[sunTr[a], {n}]
  ] /. {sunT[i_, j_] :> Sort[SUNT[i, j]],
        sunT -> SUNT, sunEps -> SUNEps} ]
]


ColourGrouping[tops_] := DiagramGrouping[ tops,
  Replace[
    ColourSimplify[Times@@
      FeynAmpCases[_[Index[Colour | Gluon, _], ___]][##]],
    _?NumberQ r_ -> r]& ]


ColourFactor[fi_ -> plain_, fj_ -> conj_] :=
  Mat[fi, fj] -> ColourSimplify[plain, conj]


Options[ColourME] = {Source :> Abbr[]}

ColourME::nomat = HelicityME::nomat

ColourME[plain_, opt___?OptionQ] := ColourME[plain, plain, opt]

ColourME[plain_, conj_, opt___?OptionQ] :=
Block[ {abbr, fabbr},
  {abbr} = ParseOpt[ColourME, opt];
  fabbr = Select[abbr, !FreeQ[#, SUNObjs]&];
  abbr = SelectArg/@ {plain, conj};
  If[ Times@@ Length/@ abbr === 0,
    Message[ColourME::nomat];
    Return[{}] ];

  Outer[ ColourFactor, abbr[[1]], abbr[[2]] ]//Flatten
]


(* squaring the matrix element *)

UniquefyIndices[conj_, plain__] :=
Block[ {ind},
  ind = Intersection@@
    (Union[Cases[#, SumOver[x_, ___] -> x, Infinity]]&)/@ {conj, plain};
  conj /. Thread[ind -> (ToSymbol[#, "c"]&)/@ ind]
]


SquaredME[amp_] := SquaredME[amp, amp]

SquaredME[Amp[_][0], _] = 0

SquaredME[_, Amp[_][0]] = 0

SquaredME[Amp[_][plain__], Amp[_][conj__]] :=
  Plus[plain] Conjugate[UniquefyIndices[Plus[conj], plain]] /;
  FreeQ[{plain, conj}, Mat]

SquaredME[Amp[_][plain__], Amp[_][conj__]] :=
  Apply[Plus,
    Outer[ ToSquared,
      MatList[Plus[plain]], MatList[UniquefyIndices[Plus[conj], plain]] ],
    {0, 1}]


MatList[expr_] := ToList[Collect[expr, _Mat, Hold]]

ToList[p_Plus] := List@@ p

ToList[other_] := {other}


ToSquared[Mat[m1_] x1_., Mat[m2_] x2_.] :=
  ReleaseHold[x1 Conjugate[x2]] ToMat[m1, m2]

ToMat[m1_Symbol, m2_Symbol] := Mat[m1, m2]

ToMat[m1_, m2_] := Inner[Mat, m1, m2, Times]


Unprotect[Conjugate]

Format[ Conjugate[x_] ] := SequenceForm[x, Superscript["*"]]

(*
Format[ Conjugate[t_Times] ] :=
  SequenceForm["(", t, ")", Superscript["*"]]
*)

Conjugate[o_SumOver] = o

Conjugate[d_IndexDelta] = d

Conjugate[p_Plus] := Conjugate/@ p

Conjugate[t_Times] := Conjugate/@ t

Conjugate[d_Den] := Conjugate/@ d

Conjugate[p_Pair] := Conjugate/@ p

Conjugate[ep_Eps] := -Conjugate/@ ep

Conjugate[e[n_]] := ec[n]

Conjugate[ec[n_]] := e[n]

Conjugate[z[n_]] := zc[n]

Conjugate[zc[n_]] := z[n]

Conjugate[eT[n_][i__]] := eTc[n][i]

Conjugate[eTc[n_][i__]] := eT[n][i]

Conjugate[k[n_]] := k[n]

Conjugate[s[n_]] := s[n]

Conjugate[x_?RealQ] = x

Conjugate[(x_?RealQ)^n_] = x^n

Protect[Conjugate]


(* performing the polarization sum analytically *)

Options[PolarizationSum] = {
  Source :> Abbr[],
  GaugeTerms -> True,
  EditCode -> False,
  RetainFile -> False }

PolarizationSum::noprocess = "No process defined so far.  PolarizationSum
works only after CalcFeynAmp."

PolarizationSum::incomp = "PolarizationSum used on an amplitude other than
the last one set up by CalcFeynAmp."

PolarizationSum[Amp[proc_][__], ___] :=
  Message[PolarizationSum::incomp] /; {CurrentProcess} =!= {proc}

PolarizationSum[amp:Amp[_][__], opt___?OptionQ] :=
Block[ {Hel},
  _Hel = 0;
  PolarizationSum[
    SquaredME[amp] /.
      HelicityME[amp, FilterOptions[HelicityME, opt]] /.
      ColourME[amp, FilterOptions[ColourME, opt]],
    opt ]
]

PolarizationSum[expr_, opt___?OptionQ] :=
Block[ {abbr, gauge, edit, retain,
fullexpr, lor, indices, legs, masses, vars, hh},

  If[ {CurrentProcess} === {},
    Message[PolarizationSum::noprocess];
    Abort[] ];

  {abbr, gauge, edit, retain} = ParseOpt[PolarizationSum, opt];

  fullexpr = expr //. abbr /. FinalFormRules;
  lor = Cases[fullexpr, _Lor, Infinity] //Union;
  indices = FormIndices[[ Level[lor, {2}] ]];
  fullexpr = fullexpr /. Thread[lor -> indices];

  legs = Cases[fullexpr, (Alternatives@@ ExtWF)[i_] -> i,
    Infinity, Heads -> True] //Union;
  masses = Level[CurrentProcess, {2}][[legs]];

  fullexpr = fullexpr /. Reverse/@ FromFormRules /.
    {Eps -> "e_", Pair -> Dot} /.
    NoExpandRule /.
    FinalFormRules;

  vars = DeclareVars[fullexpr, masses, indices, {}];

  hh = OpenForm[];
  WriteString[hh,
    vars[[1]] <> "\n\
#define GaugeTerms \"" <> ToBool[gauge] <> "\"\n" <>
    FormProcs <> "\
#include " <> ToFileName[$FormCalcProgramDir, "PolarizationSum.frm"] <> "\n\n"];

  Write[hh, "L SquaredME = ", fullexpr, ";"];

  WriteString[hh,
    MapThread[{"\n#call PolSum(", ToString[#1], ", ", ToForm[#2], ")"}&,
      {legs, masses}] <>
    "\n\n#call Emit\n"];
  Close[hh];

  Plus@@ RunForm[edit, retain][[1]]
]


FormIndices = Array[ToSymbol["FormCalc`Lor", #]&, 10]


(* set up a directory for the Fortran code *)

MkDir[dir_String] := dir /; FileType[dir] === Directory

MkDir[dir_String] := Check[CreateDirectory[dir], Abort[]]

MkDir[dirs__String] := Fold[MkDir[ToFileName[##]]&, {}, {dirs}]


Off[CopyFile::filex]

Options[SetupCodeDir] = {Drivers -> "drivers"}

SetupCodeDir[dir_, opt___Rule] :=
Block[ {drivers, path, files = {}},
  {drivers} = ParseOpt[SetupCodeDir, opt];
  path = SetDirectory[MkDir[dir]];
  ResetDirectory[];

  If[ FileType[drivers] === Directory,
    SetDirectory[drivers];
    CopyFile[#, ToFileName[path, #]]&/@ (files = FileNames[]);
    ResetDirectory[]
  ];

  If[ FileType[$DriversDir] === Directory,
    SetDirectory[$DriversDir];
    CopyFile[#, ToFileName[path, #]]&/@ Complement[FileNames[], files];
    ResetDirectory[]
  ];

  CopyFile[
    ToFileName[{$FormCalcDir, $SystemID}, "util.a"],
    ToFileName[path, "util.a"] ];

  path
]


(* Fortran code generation *)

Dim[i_Integer] = i


Attributes[WriteFF] = {HoldFirst, Listable}

WriteFF[x_Symbol, array_] :=
  FFPut[x, array, Block[{x}, ToString[x]]]

WriteFF[amp_, array_] :=
  FFPut[amp, array, ToString[array] <> ToString[++modnum]]


InvDef[h_[i_], h_[j_]] := Invariant[1, i, j] -> SInvariant[i, j]

InvDef[_[i_], _[j_]] := Invariant[-1, i, j] -> TInvariant[i, j]


InvList[n_, r__] := {InvDef[n, #]&/@ {r}, InvList[r]}

InvList[_] = {}


ProcessCheck[p_] := (
  proc = p;
  legs = Plus@@ Length/@ p;
  invs = If[ legs < 4, {},
    Flatten[InvList@@
      MapIndexed[ Apply, Drop[Flatten[{1&/@ p[[1]], -1&/@ p[[2]]}], -1] ]] ];
  header = "\n\
* this file is part of the process " <> ToString[p] <> "\n\
* generated by WriteSquaredME " <> TimeStamp[] <> "\n\n";
)

ProcessCheck[p_, p_] = 0

_ProcessCheck := Message[WriteSquaredME::incomp]


FFPut[Amp[p_][amp__], array_, file_] := (
  ProcessCheck[p, proc];
  FFWrite[#, array, file]&/@ {amp}
)

FFPut[_[], __] = {}

FFPut[other_, __] := (Message[WriteSquaredME::noamp, other]; Abort[])


FFWrite[0, __] = {}

FFWrite[amp_, array_, file_] :=
Block[ {ind, ff, mods},
  ind = Cases[amp, SumOver[i_, r_] :> (Dim[i] = r; i), Infinity];
  ff = FFList[amp /. unused[array] -> 0 /. fcs /. xrules /. {
    _SumOver -> 1,
    int:allint[__] :> abbint[int] }, array];
  mods = FileSplit[ff, file <> ({"_", ToString[#]}&)/@ ind, FFMod];
  (Indices[#] = ind)&/@ mods;
  mods
]

FFMod[ff_, mod_] :=
Block[ {file = mod <> ".F", hh},
  hh = OpenFortran[ModName[file]];
  WriteString[hh,
    "* " <> file <> header <>
    SubroutineDecl[mod] <>
    "#include \"vars.h\"\n\n"];
  WriteExpr[hh, ff, Newline -> "\n", Optimize -> True, DebugLines -> mod];
  WriteString[hh, "\tend\n"];
  Close[hh];
  mod
]


FFList[0, _] = {}

FFList[amp_, array_] :=
  ( maxmat[array] = {Mat[1]};
    RuleAdd[array[1], amp] ) /; FreeQ[amp, Mat]

FFList[amp_Plus, array_] := FFList[#, array]&/@ List@@ amp

FFList[Mat[m_] x_., array_] :=
  ( maxmat[array] = MaxDims[maxmat[array], Level[m, {-2}]];
    RuleAdd[Level[m, {-1}, array], x] )


(* Calculating the abbreviations in a clever way is key to a decent
   performance of the generated code.  Therefore, the abbreviations are
   split into three categories:
   1. objects that depend only on model constants and S
      -> subroutine abbr_s,
   2. objects that depend on other phase-space variables (angles etc.)
      -> subroutine abbr_angle,
   3. objects that depend on the helicities
      -> subroutine abbr_hel.
   The master subroutine SquaredME takes care to invoke these abbr_nnn
   subroutines only when necessary. *)

Categories[{}] = {{}, {}, {}}

Categories[abbr_] :=
Block[ {angledep},
  angledep = Alternatives@@
    (Range[Length[ proc[[2]] ]] + Length[ proc[[1]] ]);
  angledep = Alternatives@@ Append[
    Cases[invs, _[x_, r_] :> x /; MemberQ[r, angledep]],
    k[angledep] ];
  OnePassOrder/@ MoveDepsRight@@ ToCat[3, Category/@ abbr]
]


Category[rul_] := {{}, {}, rul} /;
  !FreeQ[rul[[2]], Hel | e | ec | Spinor | DottedSpinor]

Category[rul_] := {{}, rul, {}} /; !FreeQ[rul[[2]], angledep]

Category[rul_] := {rul, {}, {}}


sym[x_[__], _] = x

sym[x_, _] = x

markdep[x_, r_] := (x = TAG[++c]; {}) /; !FreeQ[r, TAG]

markdep[x___] := {x}

MoveDepsRight[li_List] := {li}

MoveDepsRight[f__List, li_List] :=
Block[ {pos = {f}, c = 0, cc = 0},
  Block[ #,
    (#1 = TAG[++c])&@@@ li;
    While[ c != cc,
      cc = c;
      pos = Apply[markdep, pos, {2}] ]
  ]&[ Union@@ Apply[sym, {f, li}, {2}] ];
  pos = Position[pos, {}, {2}, Heads -> False];
  Append[
    MoveDepsRight@@ Delete[{f}, pos],
    Flatten[{li, Extract[{f}, pos]}] ]
]


depcat[expr_][r:_[v_, _]] := (cpos = 1; {r, {}}) /; FreeQ[expr, v]

depcat[_][r_] := (cnew = 1; {{}, r})

MoveDepsLeft[li_] := {li}

MoveDepsLeft[li_, f__] :=
Block[ {pos = {f}, old = {}, new = li, cpos = 1, cnew = 1},
  While[ cpos + cnew > 1,
    old = {new, old};
    cpos = cnew = 0;
    {pos, new} = Transpose[ ToCat[2, depcat[new]/@ #1]&/@ pos ];
    new = Flatten[new] ];
  Prepend[MoveDepsLeft@@ pos, Flatten[{new, old}]]
]


OnePassOrder::recurs = "Recursive definition among ``.  For debugging
hints see $OnePassDebug.  Returning list unordered."

OnePassOrder[li_] :=
Block[ {c = 0, l = Length[li], Dep, Ticket, posmap, prev},
  Attributes[Dep] = Attributes[Ticket] = {HoldFirst};
  Ticket[a_, b_] := (a = Random[]; ++c) /; FreeQ[b, Dep];
  Block[ #,
    (#1 = Dep[#1] /. HoldPattern[Pattern][a_, _] -> a)&@@@ li;
    posmap = Ticket@@@ Hold@@ li
  ]&[ Union[sym@@@ li] ];
  While[ c < l,
    prev = c;
    posmap = Evaluate/@ posmap;
    If[ c === prev,
      $OnePassDebug = Cases[posmap,
        _[_[lhs_], rhs_] :> lhs -> rhs] /. Dep -> Identity;
      Message[OnePassOrder::recurs, First/@ $OnePassDebug];
      Return[li] ]
  ];
  li[[ Level[Sort[MapIndexed[List, posmap]], {3}] ]]
]

$OnePassDebug = {}


AbbrMod[{}, _] := Sequence[]

AbbrMod[abbr_, mod_] :=
Block[ {file = mod <> ".F", hh},
  hh = OpenFortran[ModName[file]];
  WriteString[hh,
    "* " <> file <> header <>
    SubroutineDecl[mod] <>
    "#include \"vars.h\"\n\n"];
  WriteExpr[hh, abbr, Newline -> "\n"];
  WriteString[hh, "\tend\n"];
  Close[hh];
  mod
]


NumMod[{}, _] := Sequence[]

NumMod[num_, mod_] :=
Block[ {file = mod <> ".F", hh},
  hh = OpenFortran[ModName[file]];
  WriteString[hh,
    "* " <> file <> header];
  WriteNum[hh, #]&/@ num;
  Close[hh];
  mod
]


WriteNum[hh_, var_ -> expr_] :=
Block[ {Global`res, Global`q1in},
  WriteString[hh, SubroutineDecl[var[Global`res, Global`q1in]] <> "\
\tdouble complex res, q1in(0:3)\n\n\
#include \"num.h\"\n\n"];
  WriteExpr[hh, Global`res -> expr];
  WriteString[hh, "\tend\n\n\n"];
]


$FortranPrefix = ""


VarDecl[_[], _] = ""

VarDecl[vars_, type_String] :=
Block[ {lmax = 63 - StringLength[type], llen = Infinity, vlen},
  StringJoin[
    ( llen += (vlen = StringLength[#] + 2);
      {If[llen > lmax, llen = vlen; {"\n\t", type}, ","], " ", #} )&/@
    ToFortran/@
    Replace[vars, i_Symbol :> Dim[i], {2, Infinity}] ]
]


CommonDecl[_[], __] = {}

CommonDecl[vars_, type_String, common_String] :=
  VarDecl[#, type] <>
    VarDecl[MapAt[Head, #, Position[#, _[__], 1, Heads -> False]],
      "common /" <> $FortranPrefix <> common <> "/"] <> "\n"& @
  Select[ DeleteCases[vars /. (x_ -> _) -> x, _[0] | _[]],
    !StringMatchQ[ToString[#], "tmp*"]& ]


SubroutineDecl[name_] := "\
\tsubroutine " <> $FortranPrefix <> ToFortran[name] <> "\n\
\timplicit none\n\n"


CallDecl[li_List] := StringJoin[CallDecl/@ li]

CallDecl[DoLoop[name_, ind__]] :=
  ("\n" <> #1 <> CallDecl[name] <> #2 &)@@ DoDecl[ind]

CallDecl[name_] := "\tcall " <> $FortranPrefix <> name <> "\n"


DoDecl[{var_}] := DoDecl[{var, Dim[var]}]

DoDecl[{var_, from_:1, to__}] := {
  "\tdo " <> ToFortran[var] <> " = " <> ToFortran[{from, to}] <> "\n",
  "\tenddo\n" }

DoDecl[var_] := DoDecl[{var, Dim[var]}]

DoDecl[vars__] := StringJoin/@ Transpose[DoDecl/@ Reverse[{vars}]]


	(* LoopComponents gives back e.g.
		1. {F[jFtree], SUN[jSUNtree]}
		2. "Ctree(jFtree,jSUNtree)"
		3. "Ctree, nFtree, nSUNtree"
		4. "\n\tinteger jFtree, nFtree"
		5. "\n\tparameter (nFtree = 5)"
		6. "\n\tdo jFtree = 1, nFtree
		    \n\tdo jSUNtree = 1, nSUNtree"
		7. "\n\tenddo
                    \n\tenddo" *)

LoopVar[h_[-1]] = {h[1], "", "", "", "", ""}

LoopVar[h_[n_]] :=
Block[ {v = ToString[h] <> type},
  { h[ToSymbol["j", v]],
    ", n" <> v,
    "\n\tinteger j" <> v <> ", n" <> v,
    "\n\tparameter (n" <> v <> " = " <> ToString[n] <> ")",
    "\n\tdo j" <> v <> " = 1, n" <> v,
    "\n\tenddo" }
]

LoopComponents[arr_, {}] = 0

LoopComponents[arr_, maxmat_] :=
Block[ {type = StringDrop[ToString[arr], 1]},
  {#1, ToFortran[Level[#1, {2}, arr]], ToString[arr] <> #2, ##3}&@@
  Transpose[ LoopVar/@ maxmat ]
]


Invoke[mod0_, {}] := CallDecl[mod0]

Invoke[mod0_, mod1_] := {
  CallDecl[mod0],
  "\tLOOP_IF\n",
  CallDecl[mod1],
  "\tLOOP_ENDIF\n" }


LoopReduce[m_] := Transpose[MapThread[LoopNeed, m]] /; SameQ@@ Length/@ m

LoopReduce[m_] := m /. 1 -> -1

LoopNeed[h_[1], h_[1]] := {h[-1], h[-1]}

LoopNeed[other__] := {other}


MatType[_Mat, _] = 1

MatType[h_[i_], h_[j_]] := MatType[h][i, j]

MatType[h_] := MatType[h] = ToSymbol["Mat", h]


Assort[m_Mat -> x_] := {m -> x, {}, {}, {}}

Assort[n_ -> Num[expr_]] := {{}, n -> expr, {}, {}}

Assort[f_ -> r_. w_WeylChain] := {{}, {}, {}, f -> r SplitChain@@ w}

Assort[f_ -> x_] := {{}, {}, f -> ToArray[f], {}} /;
  !FreeQ[x, DiracChain | SUNT]

Assort[other_] := {{}, {}, {}, other}


SplitChain[h1_[_[i_], _, s1_], om_, g___, h2_[_[j_], _, s2_]] :=
Block[ {om1 = 13 - om, om2 = 6 + Mod[om + Length[{g}], 2], o},
  o = om2;
  afsign[i, s1, om1] afsign[j, s2, om2] SxS[ h1[i, s1, om1],
    Fold[xs[o = 13 - o][#2, #1]&, h2[j, s2, om2], Reverse[{g}]] ]
]


afsign[i_, -1, 6] = -Hel[i]

afsign[i_, -1, 7] = Hel[i]

_afsign = 1


xs[6] = VxS

xs[7] = BxS

SxS[x_, _[-1, y_]] := SeS[x, y]

VxS[x_, _[-1, y_]] := VeS[x, y]

BxS[x_, _[-1, y_]] := BeS[x, y]


DefFilter[h_][m_[i_, j_]] :=
  h[_[m[x_, y_], _]] := x <= i && y <= j

DefCat[h_][m_[i_, j_]] :=
  h[r:_[m[x_, y_], _]] := If[x <= i && y <= j, {r, {}}, {{}, r}]


IndexHeader[h_, expr_ /; Depth[expr] > 2] :=
Block[ {ind = Symbols[Level[expr, {-2}]]},
  ind = Select[ Union[ind], Head[Dim[#]] =!= Dim & ];
  h@@ ind /; Length[ind] =!= 0
]

IndexHeader[h_, _] = h


Attributes[Cond] = {HoldRest}

Cond[True, args__] := {args}

Cond[False, __] = {}


Attributes[WriteSquaredME] = {HoldAll}

Options[WriteSquaredME] = {
  ExtraRules -> {},
  LoopSquare -> False,
  Folder -> "squaredme",
  SymbolPrefix -> "" }

WriteSquaredME::incomp = "Warning: writing out Fortran code for
incompatible processes."

WriteSquaredME::noamp = "`` is not an amplitude."

WriteSquaredME::empty = "Warning: no amplitudes were specified."

WriteSquaredME::badmat = "Incompatible matrix elements `` and ``."

WriteSquaredME[tree_, loop_, dir_, opt___Rule] :=
  WriteSquaredME[tree, loop, Abbr[], dir, opt]

WriteSquaredME[tree_, loop_, abbr__, dir_, opt___Rule] :=
Block[ {xrules, loopsq, folder, $FortranPrefix,
mat, nums, fcs, abrs, matsel, treecat, proc = Sequence[],
Dim, abbint, cints = {}, iints = {}, cc = 0, ic = 0,
ModName, Indices, Hel, hels, invs, legs,
files, hh, unused, maxmat, ntree, nloop, mats, loops,
header, ffmods, nummods, abbrmods},

  {xrules, loopsq, folder, $FortranPrefix} =
    ParseOpt[WriteSquaredME, opt];

  (ModName[mod_] := ModName[mod] = ToFileName[#, mod])& @
    MkDir[dir, folder];

(* abbint introduces abbreviations for the loop integrals.
   They fall into two categories:
   1. A0, A00 (cint..),
   2. B0i, C0i, D0i, E0i, F0i (iint..).
   For the latter the LoopTools functions [BCDE]get can be used to
   compute all tensor coefficients at once (which is much more efficient).
   Unlike the other integrals, whose results are double complex numbers,
   Cget and Dget return an integer pointing into a cache array.  In the
   conventions of LoopTools 2, the actual tensor coefficients are
   retrieved from the arrays [BCDE]val. *)

  MapThread[ (abbint[#1[i_, args__]] :=
    Block[ {uu = IndexHeader[ToSymbol["iint", ++ic], {args}]},
      iints = {iints, uu -> #2[args]};
      abbint[#1[id_, args]] = #3[id, uu];
      #3[i, uu]
    ])&, {{B0i,  C0i,  D0i,  E0i,  F0i},
          {Bget, Cget, Dget, Eget, Fget},
          {Bval, Cval, Dval, Eval, Fval}} ];

  abbint[func_] :=
  Block[ {abb = IndexHeader[ToSymbol["cint", ++cc], func]},
    cints = {cints, abb -> func};
    abbint[func] = abb
  ];

  {mat, nums, fcs, abrs} = ToCat[4, Assort/@ Flatten[{abbr}]];
  mats = First/@ DeleteCases[mat, _ -> 0];
  unused[Ctree] = Alternatives@@
    Select[Union[#[[1, 2]]&/@ mat], FreeQ[mats, Mat[_, #]]&];
  unused[Cloop] = Alternatives@@
    Select[Union[#[[1, 1]]&/@ mat], FreeQ[mats, Mat[#, _]]&];

(* Part 1: the form factors *)

  maxmat[_] = {};
  ffmods = Flatten/@ {
    Block[{modnum = 0}, WriteFF[tree, Ctree]],
    Block[{modnum = 0}, WriteFF[loop, Cloop]] };
  If[ Plus@@ Length/@ ffmods === 0,
    Message[WriteSquaredME::empty]; Return[{}] ];

(* Part 2: the numerators *)

  nummods = FileSplit[nums, "num", NumMod];
  nums = (#1 -> $FortranPrefix <> ToFortran[#1] &)@@@ nums;

(* Part 2: the variable declarations *)

  abrs = abrs /. xrules /. int:allint[__] :> abbint[int];
  iints = Flatten[iints];
  cints = Flatten[cints] /. nums;

  ntree = maxmat[Ctree];
  nloop = maxmat[Cloop];
  If[ Length[ntree] === 0, ntree = nloop,
    If[ Length[nloop] === 0, nloop = ntree,
      If[ Head/@ ntree =!= Head/@ nloop,
        Message[WriteSquaredME::badmat, ntree, nloop];
        Abort[] ];
      nloop = MaxDims[nloop, ntree];
      If[ loopsq, ntree = nloop ];
  ] ];
  mats = Select[MapThread[MatType, {nloop, ntree}], Length[#] > 0 &];

  hh = OpenWrite[ModName["vars.h"]];

  WriteString[hh, "#include \"decl.h\"\n" <>
    CommonDecl[invs, "double precision", "kinvars"] <>
    CommonDecl[{Hel[legs]}, "integer", "kinvars"] <>
    CommonDecl[abrs, "double complex", "abbrev"] <>
    CommonDecl[cints, "double complex", "loopint"] <>
    CommonDecl[iints, "integer", "loopint"] <>
    CommonDecl[
      #[[1, 1, 1]]&/@ DownValues[Dim],
      "integer", "indices"] <>
    CommonDecl[
      Flatten[{ mats,
        Level[maxmat[Ctree], {2}, Ctree],
        Level[maxmat[Cloop], {2}, Cloop] }],
      "double complex", "formfactors" ] <>
    VarDecl[Last/@ nums, "external"] <>
    "\n"
  ];

  Close[hh];

(* Part 3: the abbreviations *)

  Scan[DefFilter[matsel], mats];
  mat = Select[mat /. fcs /. Mat -> MatType, matsel];

  abrs = Flatten[{abrs, mat, cints, iints}];

  Scan[DefCat[treecat][MatType[#, #]]&, maxmat[Ctree]];
  treecat[r:_[v_, _]] := {r, {}} /; !FreeQ[tree, v];
  treecat[r_] := {{}, r};

  (* split into tree/loop *)
  abrs = Join@@ MapThread[Apply[##, 1]&,
    {{rtree, rloop}, MoveDepsLeft@@ ToCat[2, treecat/@ abrs]}];

  (* split into s/angle/hel *)
  abrs = ToCat[2, #]&/@ Replace[Categories[abrs],
    {rtree[r__] :> {Rule[r], {}},
     rloop[r__] :> {{}, Rule[r]}}, {2}];

  abbrmods = MapThread[
    FileSplit[ToDoLoops[#1], #2, AbbrMod]&,
    { abrs, {{"abbr0_s",     "abbr1_s"},
             {"abbr0_angle", "abbr1_angle"},
             {"abbr0_hel",   "abbr1_hel"}} },
    2 ];

(* Part 4: the makefile *)

  hh = OpenWrite[ModName["makefile"]];

  WriteString[hh, "\
OBJS :=" <> ({" \\\n  $(DIR)/", #, ".o"}&)/@
  Flatten[{abbrmods, nummods, ffmods, "SquaredME"}] <> "\n\n\
$(LIB): $(LIB)($(OBJS))\n\n\
$(LIB)($(OBJS)): $(DIR)/vars.h $(DECL_H)\n\n\
LIBS += $(LIB)\n\n"];

  Close[hh];

(* Part 5: the master subroutine SquaredME *)

  hels = Array[ToString[Heli[#]] -> ToString[#]&, legs];
  {maxmat[Ctree], maxmat[Cloop]} = LoopReduce[{maxmat[Ctree], maxmat[Cloop]}];
  ntree = LoopComponents[Ctree, maxmat[Ctree]];
  nloop = LoopComponents[Cloop, maxmat[Cloop]];
  loops = DeleteCases[{ntree, nloop}, 0];

  hh = OpenFortran[ModName["SquaredME.F"]];

  (* a) declarations *)
  WriteString[hh, "\
*#define CHECK\n\n\
* SquaredME.F" <> header <> "\
\tsubroutine " <> $FortranPrefix <> "SquaredME(result, helicities, flags)\n\
\timplicit none\n\
\tdouble precision result(*)\n\
\tinteger helicities, flags\n\n\
#include \"vars.h\"\n\n\
\tdouble precision " <> $FortranPrefix <> "sumup\n\
\texternal " <> $FortranPrefix <> "sumup\n" <>
    VarDecl[First/@ hels, "integer"] <>
    ({"\n\tequivalence (Hel(", #2, "), ", #1, ")"}&)@@@ hels <>
    ({"\n", #4, #5}&)@@@ loops <>
    ({"\n\tdata ", ToString[Head[#]],
      " /", ToString[Times@@ #], "*bogus/"}&)/@ mats <>
    "\n\n"];

  (* b) definitions of the invariants *)
  WriteExpr[hh, invs];

  (* c) calculation of the abbreviations *)
  WriteString[hh, "\n\
#define RESET_IF if( btest(flags, 0) ) then\n\
#define RESET_ENDIF endif\n\n\
#define LOOP_IF if( btest(flags, 1) ) then\n\
#define LOOP_ENDIF endif\n\n\
#define HEL_IF(i) if( btest(helicities, " <>
    ToString[3 legs + 1] <> "-3*i+Hel(i)) ) then\n\
#define HEL_ENDIF(i) endif\n\n\
\tRESET_IF\n" <>
    Invoke@@ abbrmods[[1]] <> "\
\tRESET_ENDIF\n\n\
\tcall markcache\n\n" <>
    Invoke@@ abbrmods[[2]] <> "\n\
\tresult(1) = 0\n\
\tresult(2) = 0\n\n" <>
    ({"\tdo ", #1, " = -1, 1\n\tHEL_IF(", #2, ")\n"}&)@@@ hels <> "\n" <>
    Invoke@@ abbrmods[[3]] <>
    ({#6, "\n\t", #2, " = 0", #7, "\n"}&)@@@ loops <>
    "\n"];

  (* d) calculation of the form factors *)
  If[ ntree =!= 0,
    WriteString[hh,
      CallDecl[ToDoLoops[ffmods[[1]], Indices]] <>
      "\n\tresult(1) = result(1) + " <> $FortranPrefix <> "sumup(",
        ntree[[3]] <> ", " <> ntree[[3]] <> ")\n"] ];

  If[ nloop =!= 0,
    WriteString[hh, "\n\tLOOP_IF\n" <>
      CallDecl[ToDoLoops[ffmods[[2]], Indices]] <>
      Cond[ ntree =!= 0,
        "\n\tresult(2) = result(2) + 2*", $FortranPrefix, "sumup(",
          nloop[[3]], ", ", ntree[[3]], ")" ] <>
      Cond[ ntree === 0 || TrueQ[loopsq],
        "\n\tresult(2) = result(2) + ", $FortranPrefix, "sumup(",
          nloop[[3]], ", ", nloop[[3]], ")" ] <>
      "\n\tLOOP_ENDIF\n"] ];

  (* e) wrapping up *)
  WriteString[hh,
    ({"\n\tHEL_ENDIF(", #2, ")\n\tenddo"}&)@@@ Reverse[hels] <>
    "\n\n\
\tcall restorecache\n\n\
#ifdef CHECK" <>
    ({"\n\tprint *, '", #, " =', ", #}&)/@
      (ToString[#1]&)@@@ invs <> "\n\n\
\tprint *, 'tree =', result(1)\n\
\tprint *, 'loop =', result(2)\n\
\tstop\n\
#endif\n\
\tend\n\n"];

  If[ ntree === 0, ntree = LoopComponents[Ctree, maxmat[Cloop]] ];
  If[ nloop === 0, nloop = LoopComponents[Cloop, maxmat[Ctree]] ];

  (* f) the sumup function *)
  WriteString[hh, "\n\
************************************************************************\n\n\
\tdouble precision function " <> $FortranPrefix <> "sumup(C" <>
      nloop[[3]] <> ", C" <> ntree[[3]] <> ")\n\
\timplicit none\n\n\
#include \"vars.h\"\n" <>
    nloop[[4]] <>
    ntree[[4]] <> "\n\
\tdouble complex C" <>
    StringReplace[nloop[[2]] <> ", C" <> ntree[[2]], "j" -> "n"] <> "\n\
\tdouble complex m\n\n\
\t" <> $FortranPrefix <> "sumup = 0\n" <>
    ntree[[6]] <> "\n\
\tm = 0" <>
    nloop[[6]] <> "\n\
\tm = m + C" <> nloop[[2]] <> "*" <>
      ToFortran[Inner[MatType, nloop[[1]], ntree[[1]], Times]] <>
    nloop[[7]] <> "\n\
\t" <> $FortranPrefix <> "sumup = " <>
      $FortranPrefix <> "sumup + DBLE(DCONJG(C" <> ntree[[2]] <> ")*m)" <>
    ntree[[7]] <> "\n\
\tend\n"];

  Close[hh];

  Cases[DownValues[ModName], _[_, s_String] -> s]
]


(* renormalization constants *)

Attributes[SelfEnergy] = {HoldRest}

SelfEnergy[f_] := SelfEnergy[f -> f, TheMass[f]]

SelfEnergy[proc_, m_] := (# /. K2 -> m^2)& @
  CalcSelfEnergy[proc, Options[InsertFields]]


Attributes[DSelfEnergy] = {HoldRest}

DSelfEnergy[f_] := DSelfEnergy[f -> f, TheMass[f]]

DSelfEnergy[proc_, m_] := (# /. K2 -> m^2)& @
  D[CalcSelfEnergy[proc, Options[InsertFields]], K2]


CalcSelfEnergy[proc_, opt_] := CalcSelfEnergy[proc, opt] =
Block[ {se, Neglect},
  Needs["FeynArts`"];
  ClearProcess[];
  se = InsertFieldsHook[
    CreateTopologies[1, Length[Flatten[{#}]]&/@ proc,
      ExcludeTopologies -> Internal],
    proc ];
  OptionalPaint[se, $PaintSE];
  se = CreateFeynAmp[se, Truncated -> !FreeQ[proc, F]];
  Plus@@ CalcFeynAmp[se, OnShell -> False, Transverse -> False,
           FermionChains -> Chiral, AbbrScale -> 1] //.
    Abbr[] /. {
    Mat -> Identity,
    Pair[_k, _k] -> K2,
	(* take only the transverse part of vector-boson SEs: *)
    Pair[_e | _ec, _k] -> If[MatchQ[proc, _V -> _V], 0, 1],
    Pair[_e, _ec] -> -1,
    SUNT[_, _] -> 1,
    SUNT[_, _, 0, 0] -> 1/2 }
]

InsertFieldsHook[args__] := InsertFields[args]


ClearSE[] := (DownValues[CalcSelfEnergy] =
  Select[DownValues[CalcSelfEnergy], #[[1, 1, 1, 0]] === Pattern &];)


OptionalPaint[ins_, True] := Paint[ins]

OptionalPaint[ins_, path_String] :=
Block[ {file = ToFileName[path, ProcessName[ins] <> ".ps"]},
  Paint[ins, DisplayFunction -> (Export[file, #]&)];
]


(* These are special versions of Re and Im where the real and
   imaginary part is taken only of the loop integrals (see A. Denner,
   Forts. Phys. 41 (1993) 307). *)

ReTilde[expr_] := expr /. int:allint[__] :> Re[int]

ImTilde[expr_] :=
  (expr /. int:allint[__] :> Im[int]) - (expr /. allint[__] -> 0)


	(* Note: it seems weird that the left-handed vector component
	   is taken as the coefficient of DiracChain[6, k]: this is
	   because DiracChain[6, k] = DiracChain[k, 7]. *)

DiracCoeff[expr_, g__] :=
  ((expr /. DiracChain[g] -> 1) - expr) /. _DiracChain -> 0

LVectorCoeff[se_] := DiracCoeff[se, 6, k[1]]

RVectorCoeff[se_] := DiracCoeff[se, 7, k[1]]

LScalarCoeff[se_] := DiracCoeff[se, 7]

RScalarCoeff[se_] := DiracCoeff[se, 6]


SEPart[f_, se_] := f[se]


Attributes[OnlyIf] = {HoldRest}

OnlyIf[True, a_, _] = a

OnlyIf[False, _, b_] = b

OnlyIf[other__] := OnlyIfEval[other]

OnlyIfEval[_, a_, a_] = a

OnlyIfEval[cond_, a_, b_] := Thread @ IndexIf[ cond,
  a /. Cases[{cond}, i_ == j_ -> (IndexDelta[i, j] -> 1), Infinity],
  b /. Cases[{cond}, i_ == j_ -> (IndexDelta[i, j] -> 0)] ]


FermionRC[m_, a_, b_, se_] :=
  m (a SEPart[LVectorCoeff, se] + b SEPart[RVectorCoeff, se]) +
     b SEPart[LScalarCoeff, se] + a SEPart[RScalarCoeff, se]

BosonRC[se_] := SEPart[Identity, se]


MassRC[f_F] := FermionRC[TheMass[f], 1/2, 1/2, ReTilde[SelfEnergy[f]]]

MassRC[f_] := BosonRC[ReTilde[SelfEnergy[f]]]

MassRC[f_, f_] := MassRC[f]

MassRC[f1_, f2_] :=
  1/2 (BosonRC[ReTilde[SelfEnergy[f2 -> f1, TheMass[f1]]]] +
       BosonRC[ReTilde[SelfEnergy[f2 -> f1, TheMass[f2]]]])


FieldRC[f_F] :=
Block[ {m = TheMass[f], se},
  se = ReTilde[SelfEnergy[f]];
  -{SEPart[LVectorCoeff, se], SEPart[RVectorCoeff, se]} -
    FermionRC[m, m, m, ReTilde[DSelfEnergy[f]]]
]

FieldRC[f_] := -BosonRC[ReTilde[DSelfEnergy[f]]]

FieldRC[f_, f_] := FieldRC[f]

FieldRC[f1_, f2_, c___] := OnlyIf[
  And@@ MapThread[Equal, Flatten[{##}]&@@@ {f1, f2}],
  FieldRC[f1],
  FieldRC2[f1, f2, c]
]

FieldRC2[f1_F, f2_F, c_:0] :=
Block[ {m1 = TheMass[f1], m2 = TheMass[f2]},
  2/(m1^2 - m2^2) (FermionRC[m2, {m2, m1}, {m1, m2},
    ReTilde[SelfEnergy[f2 -> f1, m2]]] - c)
]

FieldRC2[f1_, f2_, c_:0] :=
Block[ {m1 = TheMass[f1], m2 = TheMass[f2]},
  2/(m1^2 - m2^2) (BosonRC[ReTilde[SelfEnergy[f2 -> f1, m2]]] - c)
]


TadpoleRC[f_] := -BosonRC[ReTilde[SelfEnergy[f -> {}, Indeterminate]]]


WidthRC[f_F] := FermionRC[TheMass[f], 1, 1, ImTilde[SelfEnergy[f]]]

WidthRC[f_] := BosonRC[ImTilde[SelfEnergy[f]]]/TheMass[f]


ExecRenConst[rc_[args___]] := ExecRenConst[rc[args], Options[rc]]

ExecRenConst[rc_] := ExecRenConst[rc, Options[rc]]

ExecRenConst[rc_, {}] := RenConst[rc]

ExecRenConst[rc_, opts_] :=
Block[ {saveopts = Options[InsertFields], res},
  SetOptions[InsertFields, Sequence@@ opts];
  res = RenConst[rc];
  Options[InsertFields] = saveopts;
  res
]


RenConst::nodef =
"Warning: `` might be renormalization constants, but have no definition."

SimplePattern[h_[__]] = _h

SimplePattern[h_] = h

FindRenConst[expr_] :=
Block[ {test = {expr}, orbit, patt, rcs = {}, new, SelfEnergy, DSelfEnergy},
  Apply[ (orbit[#1] = Range[#2])&,
    { Cases[expr, SumOver[i_, r_, ___] :> {i, r}, Infinity],
      Cases[expr, IndexSum[_, r___] :> r, Infinity] }, {2} ];
  orbit[other_] = other;

  patt = Alternatives@@
    Union[ SimplePattern[ #[[1, 1, 1]] ]&/@ DownValues[RenConst] ];
  While[ Length[new = Complement[Cases[test, patt, Infinity], rcs]] =!= 0,
    rcs = Flatten[{new, rcs}];
    test = RenConst/@ new ];

  new = Select[ Names["Global`d*"],
    (FreeQ[rcs, #] && !FreeQ[expr, #]&)[
      ToExpression[#, InputForm, HoldPattern] ]& ];
  If[ Length[new] =!= 0, Message[RenConst::nodef, new] ];

  Flatten[ Distribute[#, List]&/@ Map[orbit, rcs, {2}] ] //Union
]


CalcRenConst[expr_] :=
  (# -> ExecRenConst[#])&/@ FindRenConst[expr] /. Plus -> IntCollect


IntCollect[p__] := Plus[p] /; FreeQ[{p}, Re]

(*IntCollect[p__] := Collect[Plus[p], _Re, Simplify]*)

IntCollect[p__] :=
Block[ {Simplify},
  Replace[
    Collect[ Plus[p],
      First/@ DeleteCases[Split @ Sort @ Cases[Plus[p], _Re, Infinity], {_}],
      Simplify ],
    Simplify[x_] -> x, {1} ]
]


RCMod[rcs_, mod_] :=
Block[ {file = mod <> ".F", hh},
  hh = OpenFortran[ModName[file]];
  WriteString[hh, "\
* " <> file <> "\n\
* this file contains renormalization constants" <> header <>
    SubroutineDecl[mod] <> "\
#include \"decl.h\"\n" <>
    VarDecl[Union[Cases[rcs, SumOver[i_, _] -> i, Infinity]], "integer"] <>
    "\n\n"];
  WriteExpr[hh, rcs, Newline -> "\n", Optimize -> True, DebugLines -> True];
  WriteString[hh, "\tend\n"];
  Close[hh];
  mod
]

RCAll[mod_, mods_] :=
Block[ {file = mod <> ".F", hh},
  hh = OpenFortran[ModName[file]];
  WriteString[hh,
    "* " <> file <> header <>
    SubroutineDecl[mod] <>
    ({"\n\tcall ", $FortranPrefix, #}&/@ mods) <>
    "\n\tend\n"];
  Close[hh];
  {mod, mods}
]


Options[WriteRenConst] = {
  Folder -> "renconst",
  SymbolPrefix -> "" }

WriteRenConst::norcs = "Warning: no renormalization constants found."

WriteRenConst[rcs:{___Rule}, dir_, opt___Rule] :=
Block[ {folder, $FortranPrefix, ModName, rcmods, header, hh},

  {folder, $FortranPrefix} = ParseOpt[WriteRenConst, opt];

  (ModName[mod_] := ModName[mod] = ToFileName[#, mod])& @
    MkDir[dir, folder];

  header = "\n* generated by WriteRenConst " <> TimeStamp[] <> "\n\n";

(* Part 1: CalcRenConst.F *)

  If[ Length[rcs] === 0, Message[WriteRenConst::norcs] ];

  rcmods = FileSplit[OnePassOrder[rcs], "CalcRenConst", RCMod, RCAll];

(* Part 2: renconst.h *)

  hh = OpenFortran[ModName["renconst.h"]];

  WriteString[hh, "* renconst.h\n\
* the declarations for renconst.F" <> header <>
    CommonDecl[MaxDims[Map[Dim, First/@ rcs, {2}]],
      "double complex", "renconst"] <> "\n"];

  Close[hh];

(* Part 3: the makefile *)

  hh = OpenWrite[ModName["makefile"]];

  WriteString[hh, "\
OBJS :=" <> ({" \\\n  $(DIR)/", #, ".o"}&)/@ Flatten[rcmods] <> "\n\n\
$(LIB): $(LIB)($(OBJS))\n\n\
$(LIB)($(OBJS)): $(DECL_H)\n\n\
LIBS += $(LIB)\n\n"];

  Close[hh];

  Cases[DownValues[ModName], _[_, s_String] -> s]
]

WriteRenConst[expr_, dir_, opt___Rule] :=
  WriteRenConst[CalcRenConst[expr], dir, opt]


(* low-level Fortran output functions *)

tofortran =
  "!" <> ToFileName[{$FormCalcDir, $SystemID}, "ToFortran"] <> " > "

OpenFortran[file_] := OpenWrite[tofortran <> file,
  FormatType -> FortranForm, PageWidth -> 67]


TimeStamp[] :=
  ToString[#3] <> " " <>
  {"Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug",
   "Sep", "Oct", "Nov", "Dec"}[[#2]] <> " " <>
  ToString[#1] <> " " <>
  ToString[#4] <> ":" <>
  StringTake["0" <> ToString[#5], -2]&@@ Date[]


(* The following routines are concerned with breaking a large
   expression into pieces the Fortran compiler will compile.
   This is controlled by two variables:

   - $BlockSize is the maximum LeafCount a single Fortran statement
     may have.  The cutting-up of expressions into such blocks is
     performed by the function WriteExpr.

   - $FileSize is the maximum LeafCount a whole file may have.
     The function which separates large expressions into file-size
     fragments is SizeSplit. *)

Attributes[batch] = {Flat}

Coalesce[(ru:Rule | RuleAdd)[v_, p_Plus], r___] :=
  Level[
    { ReplacePart[
        RuleAdd[v, Plus@@ #]&/@ Flatten[Coalesce@@ p],
        ru, {1, 0} ],
      {r} }, {2}, Coalesce ] /; LeafCount[p] > size

Coalesce[a_, b_, r___] :=
  Coalesce[batch[a, b], r] /; LeafCount[{a, b}] < size

Coalesce[a_, r___] := {batch[a], Coalesce[r]}

Coalesce[] = {}


Attributes[BlockSplit] = {Listable}

BlockSplit[expr_] := expr /; LeafCount[expr] < $BlockSize

BlockSplit[expr_] :=
Block[ {size = $BlockSize},
  List@@@ Flatten[Coalesce[expr]]
]


FileSplit[expr_List, mod_, writemod_, ___] :=
  {writemod[expr, mod]} /; LeafCount[expr] < $FileSize

FileSplit[expr_List, mod_, writemod_, writeall_:(#2&)] :=
Block[ {size = $FileSize},
  writeall[mod, MapIndexed[
    writemod[List@@ #1, mod <> ToString[ #2[[1]] ]]&,
    Flatten[Coalesce@@ expr] ]]
]

FileSplit[other_, r__] := FileSplit[{other}, r]


ToTmp[s_Symbol] = s

ToTmp[expr_] := (Sow[# -> expr]; #)& @ Unique["tmp"]


Attributes[TmpList] = {HoldFirst}

TmpList[expr_] := Reverse[Reap[expr]]


RemoveDups[expr_] :=
  Fold[RemoveDups, #, -Range[3, Depth[#] - 1]]& @ Flatten[{expr}]

RemoveDups[expr_, level_] :=
Block[ {obj, elem, tmps, new},
  _obj = {};
  elem[{p_, r___}] := (obj[#] = {obj[#], p})& @ expr[[p, r]];
  elem/@ Position[ expr /. {_DoLoop -> 1, _IndexIf -> 1},
    p_Plus /; LeafCount[N[p]] > minleaf,
    {level}, Heads -> False ];
  tmps = Cases[ DownValues[obj],
    _[_[_[x_]], p_ /; Depth[p] > 3] :> {x -> dup[++dupc], Min[p]} ];
  new = Block[{Plus}, Apply[Set, tmps, {2}]; expr];
  new = #1 /. Flatten[#2] & @@
    Reap[new /. r:(_dup -> _dup) :> (Sow[r]; {})];
  Fold[ InsertDef, new, Reverse[tmps] ] //Flatten
]

InsertDef[expr_, {var_ -> tmp_, pos_}] :=
  MapAt[{tmp -> var, #}&, expr, pos]


Attributes[SplitExpr] = {Listable}

SplitExpr[(ru:Rule | RuleAdd)[var_, expr_]] :=
  BlockSplit @ TmpList[ ru[var,
    Replace[expr, p_Plus :> ToTmp[p] /; LeafCount[p] > $BlockSize,
      {1, Infinity}]] ]

SplitExpr[other_] = other


Attributes[RhsApply] = {Listable}

RhsApply[(ru:Rule | RuleAdd)[var_, expr_], foo_] := ru[var, foo[expr]]

RhsApply[other_, _] = other


Options[PrepareExpr] = {
  Optimize -> False,
  MinLeafCount -> 10,
  DebugLines -> False,
  FinalTouch -> Identity }

PrepareExpr[expr_, opt___Rule] :=
Block[ {optim, minleaf, debug, final, new, vars, tmps, dup, dupc = 0},
  {optim, minleaf, debug, final} = ParseOpt[PrepareExpr, opt];
  process = Flatten[RhsApply[SplitExpr @ Prep[#], final]] &;
  If[ TrueQ[optim], process = process /. p_Prep :> RemoveDups[p] ];
  new = Flatten[{expr}];
  vars = Cases[new, (ru:Rule | RuleAdd)[var_, _] -> var, Infinity];
  If[ debug =!= False, new = AddDebug[new, debug] ];
  new = process[new];
  dup[c_] := dup[c] = Unique["dup"];
  new = new;
  tmps = Cases[new, (ru:Rule | RuleAdd)[var_, _] -> var, Infinity];
  FortranExpr[vars, Complement[tmps, vars], new]
]


Attributes[AddDebug] = {Listable}

AddDebug[DoLoop[expr_, ind__], tag_] :=
  DoLoop[{DebugLine[#1&@@@ {ind}, tag], AddDebug[expr, tag]}, ind]

AddDebug[(ru:Rule | RuleAdd)[var_, expr_], tag_] :=
  {ru[var, expr], DebugLine[var, tag]}

DebugLine[var_, True] := DebugLine[var]


Attributes[Prep] = {Listable}

Prep[DoLoop[expr_, ind__]] := DoLoop[process[expr], ind]

Prep[(ru:Rule | RuleAdd)[var_, IndexIf[cond_, a_, b_]]] :=
  IndexIf[cond, process[ru[var, a]], process[ru[var, b]]]

Prep[(ru:Rule | RuleAdd)[var_, expr_]] := Prep @
  MapIndexed[IniLHS[ru, var],
    ToDoLoops[SplitSums[expr]] /. _SumOver -> 1] /;
  !FreeQ[expr, SumOver]

Prep[(ru:Rule | RuleAdd)[var_, expr_]] := Prep @
  TmpList[ru[var, expr /. i_IndexIf :> ToTmp[i]]] /;
  !FreeQ[expr, IndexIf]

Prep[other_] = other


IniLHS[Rule, lhs_][DoLoop[rhs_, ind__], {1}] :=
  {lhs -> 0, DoLoop[RuleAdd[lhs, Plus@@ rhs], ind]}

IniLHS[Rule, lhs_][rhs_, {1}] := lhs -> rhs

IniLHS[_, lhs_][DoLoop[rhs_, ind__], _] :=
  DoLoop[RuleAdd[lhs, Plus@@ rhs], ind]

IniLHS[_, lhs_][rhs_, _] := RuleAdd[lhs, rhs]


SplitSums[li_List, wrap___] := SplitSums[Plus@@ li, wrap]

SplitSums[x_, wrap_:Identity] := {wrap[x]} /; FreeQ[x, SumOver]

SplitSums[x_, wrap_:Identity] :=
Block[ {term},
  term[_] = 0;
  assign[Expand[x, SumOver]];
  term[_] =.;
  #[[1, 1, 1]] wrap[Plus@@ Flatten[ #[[2]] ]]&/@ DownValues[term]
]

assign[p_Plus] := assign/@ p

assign[t_Times] := (term[#1] = {term[#1], #2})&@@ cull/@ t

assign[other_] := term[1] = {term[1], other}

cull[o_SumOver] := {o, 1}

cull[other_] := {1, other}


FindIndices[var_ -> _] := Union[Cases[var, _Symbol]]

FindIndices[t_Times] := Cases[t, SumOver[i__] -> {i}]

FindIndices[_] = {}

ToDoLoops[li_List, indices_:FindIndices] :=
Block[ {do},
  do[_] = {};
  Scan[(do[#1] = {do[#1], #2})&[indices[#], #]&, li];
  Cases[ DownValues[do],
    _[_[_[{ind___}]], a_] :> DoLoop[Flatten[a], ind] ]
]

ToDoLoops[other_, ___] = other


DoLoop[{a___}] = a

DoLoop[a_] = a


Options[WriteExpr] = {
  HornerStyle -> True,
  Type -> False,
  TmpType -> (*Type*) "double complex",
  RealArgs -> Level[{allint, Bget, Cget, Dget, Eget, Log, Sqrt}, {-1}],
  Newline -> "" }

WriteExpr[_, _[], ___] = {}

WriteExpr[hh_, FortranExpr[vars_, tmpvars_, expr_], opt___Rule] :=
Block[ {horner, type, tmptype, dargs, newline, block = 0},
  {horner, type, tmptype, dargs, newline} = ParseOpt[WriteExpr, opt];
  dargs = Alternatives@@ dargs;
  horner = If[ TrueQ[horner],
    p_Plus :> (HornerForm[p] /. HornerForm -> Identity) /; Depth[p] < 6,
    {} ];
  WriteString[hh,
    VarType[vars, type] <>
    VarType[tmpvars, tmptype /. Type -> type]];
  WriteBlock[hh, expr]
]

WriteExpr[hh_, expr_, opt___Rule] :=
  WriteExpr[hh, PrepareExpr[expr, FilterOptions[PrepareExpr, opt]],
    FilterOptions[WriteExpr, opt]]


VarType[vars:{__}, type_String] :=
  {StringDrop[VarDecl[vars, type], 1], "\n\n"}

VarType[__] = ""


Attributes[WriteBlock] = {Listable}

WriteBlock[hh_, s_String] := (WriteString[hh, s <> newline]; s)

WriteBlock[hh_, DebugLine[var_, tag___]] :=
  WriteBlock[hh,
    "#ifdef DEBUG\n\tDEB '" <>
      ({ToString[#], ": "}&)/@ {tag} <> # <> " =', " <> # <>
      "\n#endif\n"]& @
    ToFortran[var]

WriteBlock[hh_, DoLoop[expr_, ind__]] :=
  WriteBlock[hh, {#1, expr, #2}]&@@ DoDecl[ind]

WriteBlock[hh_, IndexIf[cond_, a_, b_]] :=
  WriteBlock[hh, {
    "\tif( " <> ToFortran[cond] <> " ) then\n", a,
    Cond[ !MatchQ[b, {RuleAdd[_, 0]}], "\telse\n", b ],
    "\tendif\n" }]

WriteBlock[hh_, ru_[var_, {sub__, expr_}]] :=
  WriteBlock[hh, {sub, ru[var, expr]}]

WriteBlock[_, RuleAdd[_, 0]] := Sequence[]

WriteBlock[hh_, RuleAdd[var_, expr_]] :=
  WriteBlock[hh, var -> var + expr]

WriteBlock[hh_, var_ -> expr_] := (
  Write[hh, var -> (expr /.
    {Conjugate -> DCONJG, Re -> DBLE, Im -> DIMAG,
      Complex[a_, b_] -> a + cI b} /.
    E^x_ :> exp[x] /.
    f:dargs[__] :> NArgs/@ f /.
    p_Integer^r_Rational :> (HoldForm[#]^r &)[ N[p] ] /.
    (* p:_Integer^_Rational :> N[p] /. *)
    Den[p_, m_] -> 1/(p - m) /.
    horner /.
    Times -> OptTimes)];
  WriteString[hh, newline];
  var -> expr
)


NArgs[0] = 0.

NArgs[i_Integer] := N[i]

NArgs[x_] = x


Unprotect[Rule, Rational, Power]

Format[a_ -> b_, FortranForm] := SequenceForm[a, " = ", b]

Format[Rational[a_, b_], FortranForm] := HoldForm[a]/b

Format[a_^n_Integer /; n < -1, FortranForm] := (1/HoldForm[#] &)[ a^-n ]

Protect[Rule, Rational, Power]


OptTimes[t__] :=
Block[ {p = Position[N[{t}], _Real, 1, Heads -> False]},
  OptNum[Times@@ Extract[{t}, p], Times@@ Delete[{t}, p]]
]

OptNum[const_, 1] = const

OptNum[const_Integer, var_] := const var

OptNum[n_?Negative r_., var_] := -OptNum[-n r, var]

OptNum[const_, var_] := HoldForm[HoldForm[const] var]

End[]


Format[ _Continuation ] = "    "
  (* eliminate those `>' in front of continuation lines so one can cut
     and paste more easily *)

$FormCmd = ToFileName[{$FormCalcDir, "FORM"}, "form_" <> $SystemID]
  (* the filename of the actual FORM executable; may contain a path *)

FormSetup = "\
#-\n\
#:SmallSize 5000000\n\
#:LargeSize 10000000\n\
#:WorkSpace 10000000\n\
#:MaxTermSize 150000\n\
#:TermsInSmall 30000\n\
#:TempDir " <> DirectoryName[$TemporaryPrefix] <> "\n\
off stats;\n\n"

$Editor = "${VISUAL:-xterm -e nano} `` &"
  (* editor to use when debugging FORM code *)

$BlockSize = 700

$FileSize = 30 $BlockSize

$RecursionLimit = 1024

$DriversDir = ToFileName[{$FormCalcDir, "drivers"}]

$PaintSE = False

EndPackage[]


(* global definitions for specific models *)

powQ[1] = powQ[-1] = False

powQ[other_] := IntegerQ[other]

Sq/: (Sq[v_] = v2_) := (
  v^(n_?EvenQ) ^:= v2^(n/2);
  (v^(n_?powQ) ^:= v2^((n - Sign[n])/2) #^Sign[n])&[ v /. Pattern -> (#1&) ];
  Square[v] = v2
)


(* definitions for the Standard Model *)

Sq[EL] = 4 Pi Alfa;
Sq[Alfa] = Alfa2;
Sq[GS] = 4 Pi Alfas;
Sq[Alfas] = Alfas2

Sq[SW] = SW2;
Sq[CW] = CW2;
CW2/: CW2 + SW2 = 1

Sq[MZ] = MZ2;
Sq[MW] = MW2;
Sq[MH] = MH2;

Sq[ME] = ME2;  Sq[MM] = MM2;  Sq[ML] = ML2;
Sq[MU] = MU2;  Sq[MC] = MC2;  Sq[MT] = MT2;
Sq[MD] = MD2;  Sq[MS] = MS2;  Sq[MB] = MB2

MLE[a__] := Mf[2, a];
MQU[a__] := Mf[3, a];
MQD[a__] := Mf[4, a];
Sq[Mf[a__]] = Mf2[a]

Mf[2, 1] = ME;  Mf[2, 2] = MM;  Mf[2, 3] = ML;
Mf[3, 1] = MU;  Mf[3, 2] = MC;  Mf[3, 3] = MT;
Mf[4, 1] = MD;  Mf[4, 2] = MS;  Mf[4, 3] = MB

Mf2[2, 1] = ME2;  Mf2[2, 2] = MM2;  Mf2[2, 3] = ML2;
Mf2[3, 1] = MU2;  Mf2[3, 2] = MC2;  Mf2[3, 3] = MT2;
Mf2[4, 1] = MD2;  Mf2[4, 2] = MS2;  Mf2[4, 3] = MB2

Conjugate[CKM[a__]] ^:= CKMC[a];
Conjugate[CKMC[a__]] ^:= CKM[a]

SUNN = 3

(* these symbols represent real quantities, i.e. Conjugate[sym] = sym
   for any of these.  Thinking e.g. of complex masses this looks
   dangerous but then again it's easy to remove any such definition.
   The function that really needs this is SquaredME. *)

Scan[ (RealQ[#] = True)&,
  { EL, Alfa, Alfa2, GS, Alfas, Alfas2,
    SW, CW, SW2, CW2,
    MW, MW2, MZ, MZ2,
    MH, MH2, MG0, MG02, MGp, MGp2,
    ME, ME2, MM, MM2, ML, ML2,
    MU, MU2, MC, MC2, MT, MT2,
    MD, MD2, MS, MS2, MB, MB2, _Mf, _Mf2 } ]

(* Model parameters which are defined using the parameter statement in
   Fortran (i.e. as numeric constants; see model.h) are given some
   numeric value here.  Using this information, the OptTimes function can
   significantly optimize the generated Fortran code.  The idea is to put
   everything that is known as constant at compile time in one place,
   i.e. rearrange products such that they are of the form (const)*(vars),
   then the compiler will usually collect all of these constants into one
   number. *)

Scan[ (N[#] = Random[])&,
  { cI, Alfa, Alfa2, SW2, CW, CW2,
    MW, MW2, MZ, MZ2,
    ME, ME2, MM, MM2, ML, ML2,
    MU, MU2, MC, MC2, MT, MT2,
    MD, MD2, MS, MS2, MB, MB2 } ]


(* definitions for the MSSM *)

SetOptions[CalcFeynAmp,
  NoExpand -> {USf, USfC, UASf, UASfC,
    UCha, UChaC, VCha, VChaC, ZNeu, ZNeuC,
    UHiggs, UHiggsC, ZHiggs, ZHiggsC}]

Af[t_, g_] := Af[t, g, g]

USf[t_, g_][a_, b_] := USf[a, b, t, g];
UASf[t_][a_, b_] := UASf[a, b, t]

Conjugate[USf[a__]] ^:= USfC[a];
Conjugate[USfC[a__]] ^:= USf[a]

Conjugate[UASf[a__]] ^:= UASfC[a];
Conjugate[UASfC[a__]] ^:= UASf[a]

Conjugate[UCha[a__]] ^:= UChaC[a];
Conjugate[UChaC[a__]] ^:= UCha[a]

Conjugate[VCha[a__]] ^:= VChaC[a];
Conjugate[VChaC[a__]] ^:= VCha[a]

Conjugate[ZNeu[a__]] ^:= ZNeuC[a];
Conjugate[ZNeuC[a__]] ^:= ZNeu[a]

Conjugate[UHiggs[a__]] ^:= UHiggsC[a];
Conjugate[UHiggsC[a__]] ^:= UHiggs[a]

Conjugate[ZHiggs[a__]] ^:= ZHiggsC[a];
Conjugate[ZHiggsC[a__]] ^:= ZHiggs[a]

Conjugate[Af[a__]] ^:= AfC[a];
Conjugate[AfC[a__]] ^:= Af[a]

Conjugate[MUE] ^:= MUEC;
Conjugate[MUEC] ^:= MUE

Conjugate[SqrtEGl] ^:= SqrtEGlC;
Conjugate[SqrtEGlC] ^:= SqrtEGl

SqrtEGl/: SqrtEGl SqrtEGlC = 1

Sq[SA] = SA2;
Sq[CA] = CA2;
CA2/: CA2 + SA2 = 1

Sq[TB] = TB2;
Sq[SB] = SB2;
Sq[CB] = CB2;
CB2/: CB2 + SB2 = 1

Sq[MGl] = MGl2;
Sq[MSf[a__]] = MSf2[a];
Sq[MASf[a__]] = MASf2[a];
Sq[MCha[a__]] = MCha2[a];
Sq[MNeu[a__]] = MNeu2[a]

Sq[Mh0] = Mh02;  Sq[Mh0tree] = Mh0tree2;
Sq[MHH] = MHH2;  Sq[MHHtree] = MHHtree2;
Sq[MA0] = MA02;  Sq[MA0tree] = MA0tree2;
Sq[MHp] = MHp2;  Sq[MHptree] = MHptree2

Scan[ (RealQ[#] = True)&,
  { TB, CB, SB, CA, SA, CB2, SB2, C2A, S2A, CAB, SAB, CBA, SBA,
    Mh0, Mh02, MHH, MHH2, MA0, MA02, MHp, MHp2,
    _MSf, _MSf2, _MCha, _MCha2, _MNeu, _MNeu2 } ]


(* make Needs["FeynArts`"] work after loading FormCalc *)

If[ !NameQ["FeynArts`$FeynArts"],
  Unprotect[$Packages];
  $Packages = DeleteCases[$Packages, "FeynArts`"];
  Protect[$Packages] ]

Null

