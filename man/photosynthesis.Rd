% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/photosynthesis.R
\encoding{UTF-8}
\name{photosynthesis}
\alias{photosynthesis}
\alias{photo}
\title{Simulate C3 photosynthesis}
\usage{
photosynthesis(leaf_par, enviro_par, bake_par, constants,
  progress = TRUE, quiet = FALSE, parallel = FALSE)

photo(leaf_par, enviro_par, bake_par, constants, quiet = FALSE)
}
\arguments{
\item{leaf_par}{A list of leaf parameters inheriting class \code{leaf_par}. This can be generated using the \code{make_leafpar} function.}

\item{enviro_par}{A list of environmental parameters inheriting class \code{enviro_par}. This can be generated using the \code{make_enviropar} function.}

\item{bake_par}{A list of temperature response parameters inheriting class \code{bake_par}. This can be generated using the \code{make_bakepar} function.}

\item{constants}{A list of physical constants inheriting class \code{constants}. This can be generated using the \code{make_constants} function.}

\item{progress}{Logical. Should a progress bar be displayed?}

\item{quiet}{Logical. Should messages be displayed?}

\item{parallel}{Logical. Should parallel processing be used via \code{\link[furrr]{future_map}}?}
}
\value{
A data.frame with the following \code{units} columns \cr

\tabular{ll}{

\bold{Input:} \tab \cr
\cr
\code{C_air} \tab atmospheric CO2 concentration (Pa) \cr
\code{g_mc25} \tab mesophyll conductance to CO2 at 25 °C (\eqn{\mu}mol CO2 / (m\eqn{^2} s Pa)) \cr
\code{g_sc} \tab stomatal conductance to CO2 (\eqn{\mu}mol CO2 / (m\eqn{^2} s Pa)) \cr
\code{g_uc} \tab cuticular conductance to CO2 (\eqn{\mu}mol CO2 / (m\eqn{^2} s Pa)) \cr
\code{gamma_star25} \tab chloroplastic CO2 compensation point at 25 °C (Pa) \cr
\code{J_max25} \tab potential electron transport at 25 °C (\eqn{\mu}mol CO2) / (m\eqn{^2} s) \cr
\code{K_C25} \tab Michaelis constant for carboxylation at 25 °C (\eqn{\mu}mol / mol) \cr
\code{K_O25} \tab Michaelis constant for oxygenation at 25 °C (\eqn{\mu}mol / mol) \cr
\code{k_mc} \tab partition of \eqn{g_\mathrm{mc}}{g_mc} to lower mesophyll (unitless) \cr
\code{k_sc} \tab partition of \eqn{g_\mathrm{sc}}{g_sc} to lower surface (unitless) \cr
\code{k_uc} \tab partition of \eqn{g_\mathrm{uc}}{g_uc} to lower surface (unitless) \cr
\code{leafsize} \tab leaf characteristic dimension (m) \cr
\code{O} \tab atmospheric O2 concentration (kPa) \cr
\code{P} \tab atmospheric pressure (kPa) \cr
\code{phi_J} \tab initial slope of the response of J to PPFD (unitless) \cr
\code{PPFD} \tab photosynthetic photon flux density (umol quanta / (m\eqn{^2} s)) \cr
\code{R_d25} \tab nonphotorespiratory CO2 release  at 25 °C (\eqn{\mu}mol CO2 / (m\eqn{^2} s)) \cr
\code{RH} \tab relative humidity (unitless) \cr
\code{theta_J} \tab curvature factor for light-response curve (unitless) \cr
\code{T_air} \tab air temperature (K) \cr
\code{T_leaf} \tab leaf tempearture (K) \cr
\code{V_cmax25} \tab maximum rate of carboxylation at 25 °C (\eqn{\mu}mol CO2 / (m\eqn{^2} s)) \cr
\code{V_tpu25} \tab rate of triose phosphate utilisation at 25 °C (\eqn{\mu}mol CO2 / (m\eqn{^2} s)) \cr
\code{wind} \tab wind speed (m / s) \cr
\cr
\bold{Baked Input:} \tab \cr
\cr
\code{g_mc} \tab mesophyll conductance to CO2 at \code{T_leaf} (\eqn{\mu}mol CO2 / (m\eqn{^2} s Pa)) \cr
\code{gamma_star} \tab chloroplastic CO2 compensation point at \code{T_leaf} (Pa) \cr
\code{J_max} \tab potential electron transport at \code{T_leaf} (\eqn{\mu}mol CO2) / (m\eqn{^2} s) \cr
\code{K_C} \tab Michaelis constant for carboxylation at \code{T_leaf} (\eqn{\mu}mol / mol) \cr
\code{K_O} \tab Michaelis constant for oxygenation at \code{T_leaf}(\eqn{\mu}mol / mol) \cr
\code{R_d} \tab nonphotorespiratory CO2 release  at \code{T_leaf} (\eqn{\mu}mol CO2 / (m\eqn{^2} s)) \cr
\code{V_cmax} \tab maximum rate of carboxylation at \code{T_leaf} (\eqn{\mu}mol CO2 / (m\eqn{^2} s)) \cr
\code{V_tpu} \tab rate of triose phosphate utilisation at \code{T_leaf} (\eqn{\mu}mol CO2 / (m\eqn{^2} s)) \cr
\cr
\bold{Output:} \tab \cr
\cr
\code{A} \tab photosynthetic rate at \code{C_chl} (\eqn{\mu}mol CO2 / (m\eqn{^2} s)) \cr
\code{C_chl} \tab chloroplastic CO2 concentration where \code{A_supply} intersects \code{A_demand} (Pa) \cr
\code{g_tc} \tab total conductance to CO2 at \code{T_leaf} (\eqn{\mu}mol CO2 / (m\eqn{^2} s Pa)) \cr
\code{value} \tab \code{A_supply} - \code{A_demand} (\eqn{\mu}mol CO2 / (m\eqn{^2} s)) at \code{C_chl} \cr
\code{convergence} \tab convergence code (0 = converged)
}
}
\description{
\code{photosynthesis}: simulate C3 photosynthesis over multiple parameter sets

\code{photo}: simulate C3 photosynthesis over a single parameter set
}
\details{
\code{photo}: This function takes simulates photosynthetic rate using the Farquhar-von Caemmerer-Berry (\code{\link{FvCB}}) model of C3 photosynthesis for single combined set of leaf parameters (\code{\link{leaf_par}}), environmental parameters (\code{\link{enviro_par}}), and physical constants (\code{\link{constants}}). Leaf parameters are provided at reference temperature (25 °C) and then "baked" to the appropriate leaf temperature using temperature response functions (see \code{\link{bake}}). \cr
\cr
\code{photosynthesis}: This function uses \code{photo} to simulate photosynthesis over multiple parameter sets that are generated using \code{\link[tidyr]{crossing}}. \cr
}
\examples{
# Single parameter set with 'photo'

leaf_par <- make_leafpar()
enviro_par <- make_enviropar()
bake_par <- make_bakepar()
constants <- make_constants()
photo(leaf_par, enviro_par, bake_par, constants)

# Multiple parameter sets with 'photosynthesis'

leaf_par <- make_leafpar(
  replace = list(
    T_leaf = set_units(c(293.14, 298.15), "K")
    )
  )
enviro_par <- make_enviropar()
bake_par <- make_bakepar()
constants <- make_constants()
photosynthesis(leaf_par, enviro_par, bake_par, constants)

}
