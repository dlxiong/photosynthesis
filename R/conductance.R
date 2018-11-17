#' Conductance to CO2 (umol / (m^2 s Pa))
#'
#' @inheritParams A_supply
#'
#' @name CO2_conductance
#' 
#' @encoding UTF-8
#' 

NULL

#'  - g_tc: total conductance to CO2
#' 
#' @rdname CO2_conductance
#' 
#' @details 
#' 
#' Total conductance to CO2 is the sum of parallel conductances on the lower (\eqn{gc_\mathrm{lower}}{gc_lower}) and upper (\eqn{gc_\mathrm{upper}}{gc_upper}) leaf surfaces that are in series with intercellular conductance (\eqn{g_\mathrm{ic}}{g_ic}):
#' 
#' \deqn{g_\mathrm{tc} = 1 / ((1 / g_\mathrm{ic}) + (1 / (gc_\mathrm{upper} + gc_\mathrm{lower})))}{g_tc = 1 / ((1 / g_ic) + (1 / (gc_upper + gc_lower)))}
#' 
#' The upper and lower conductances are determined by the intercellular (\eqn{g_\mathrm{xc}}{g_xc}) and stomatal (\eqn{g_\mathrm{sc}}{g_sc}) conductances in series. For a naming convenction, I assume that the lower surface is abaxial and conists of spongy mesophyll; the upper surface is adaxial and consists of palisade mesophyll:
#' 
#' \deqn{gc_\mathrm{lower} = 1 / ((1 / gsc_\mathrm{abaxial}) + (1 / gxc_\mathrm{spongy}))}{gc_lower = 1 / ((1 / gsc_abaxial) + (1 / gxc_spongy))}
#' \deqn{gc_\mathrm{upper} = 1 / ((1 / gsc_\mathrm{adaxial}) + (1 / gxc_\mathrm{palisade}))}{gc_upper = 1 / ((1 / gsc_adaxial) + (1 / gxc_palisade))}
#' 
#' The total stomatal and intercellular conductances are partitioned between abaxial/adaxial and spongy/palisade, respectively, according to two partitioning facotrs \eqn{k_\mathrm{sc}}{k_sc} and \eqn{k_\mathrm{xc}}{k_xc}:
#' 
#' \deqn{gsc_\mathrm{abaxial} = g_\mathrm{sc} (1 / (1 + k_\mathrm{sc}))}{gsc_abaxial = g_sc (1 / (1 + k_sc))}
#' \deqn{gsc_\mathrm{adaxial} = g_\mathrm{sc} (k_\mathrm{sc} / (1 + k_\mathrm{sc}))}{gsc_adaxial = g_sc (k_sc / (1 + k_sc))}
#' \deqn{gxc_\mathrm{spongy} = g_\mathrm{xc} (1 / (1 + k_\mathrm{xc}))}{gxc_\mathrm{spongy} = g_\mathrm{xc} (1 / (1 + k_\mathrm{xc}))}
#' \deqn{gxc_\mathrm{palisade} = g_\mathrm{xc} (k_\mathrm{xc} / (1 + k_\mathrm{xc}))}{gxc_palisade = g_xc (k_xc / (1 + k_xc))}
#' 
#' 
#' \tabular{lllll}{
#' \emph{Symbol} \tab \emph{R} \tab \emph{Description} \tab \emph{Units} \tab \emph{Default}\cr
#' \eqn{g_\mathrm{sc}}{g_sc} \tab \code{g_sc} \tab stomatal conductance to CO2 \tab (\eqn{\mu}mol CO2) / (m\eqn{^2} s Pa) \tab 5\cr
#' \eqn{g_\mathrm{xc}}{g_xc} \tab \code{g_xc} \tab intercellular conductance to CO2 \tab (\eqn{\mu}mol CO2) / (m\eqn{^2} s Pa) \tab 10 \cr
#' \eqn{g_\mathrm{ic}}{g_ic} \tab \code{g_ic} \tab intracellular conductance to CO2 \tab (mol CO2) / (m\eqn{^2} s) \tab 10 \cr
#' \eqn{k\mathrm{xs}}{k_sc} \tab \code{k_sc} \tab partition of \eqn{g_\mathrm{sc}}{g_sc} to abaxial (lower) surface \tab none \tab 1 \cr
#' \eqn{k\mathrm{xc}}{k_xc} \tab \code{k_xc} \tab partition of \eqn{g_\mathrm{xc}}{g_xc} to spongy mesophyll \tab none \tab 1
#' }
#' 

.get_gtc <- function(pars) {
  
  # SAVE FOR LATER
  # gsc_adaxial <- pars$g_sc * (pars$k_sc / (set_units(1) + pars$k_sc))
  # gsc_abaxial <- pars$g_sc * (set_units(1) / (set_units(1) + pars$k_sc))
  # gxc_palisade <- pars$g_xc * (pars$k_xc / (set_units(1) + pars$k_xc))
  # gxc_spongy <- pars$g_xc * (set_units(1) / (set_units(1) + pars$k_xc))
  # gc_lower <- set_units(1) / ((set_units(1) / gsc_abaxial) + (set_units(1) / gxc_spongy))
  # gc_upper <- set_units(1) / ((set_units(1) / gsc_adaxial) + (set_units(1) / gxc_palisade))
  # g_tc <- set_units(1) / ((set_units(1) / pars$g_ic) + (set_units(1) / (gc_lower + gc_upper)))
  # g_tc %<>% set_units("umol/m^2/s/Pa")
  
  gbc_lower <- .get_gbc(pars, "lower")
  gmc_lower <- .get_gmc(pars, "lower")
  gsc_lower <- .get_gsc(pars, "lower")
  guc_lower <- .get_guc(pars, "lower")
  
  gbc_upper <- .get_gbc(pars, "upper")
  gmc_upper <- .get_gmc(pars, "upper")
  gsc_upper <- .get_gsc(pars, "upper")
  guc_upper <- .get_guc(pars, "upper")
  
  rc_lower <- 1 / gmc_lower + 1 / gsc_lower + 1 / gbc_lower
  gc_lower <- 1 / rc_lower
  gc_lower %<>% magrittr::add(guc_lower)

  rc_upper <- 1 / gmc_upper + 1 / gsc_upper + 1 / gbc_upper
  gc_upper <- 1 / rc_upper
  gc_upper %<>% magrittr::add(guc_upper)
  
  g_tc <- gc_lower + gc_upper
  
  g_tc %<>% set_units("umol/m^2/s/Pa")
  
  g_tc
  
}

#'  - g_uc: cuticular conductance to CO2
#' 
#' @param surface Leaf surface (lower or upper)
#' 
#' @rdname CO2_conductance

.get_guc <- function(pars, surface) {
  
  surface %<>% match.arg(c("lower", "upper"))
  
  g_uc <- switch(surface,
    lower = pars$g_uc * (set_units(1) / (set_units(1) + pars$k_uc)),
    upper = pars$g_uc * (pars$k_uc / (set_units(1) + pars$k_uc))
  )

  g_uc
  
}

#'  - g_bc: boundary layer conductance to CO2
#' 
#' @inheritParams .get_guc
#' 
#' @rdname CO2_conductance

.get_gbc <- function(pars, surface) {
  
  surface %<>% match.arg(c("lower", "upper"))
  
  D_c <- .get_Dx(pars$D_c0, (pars$T_air + pars$T_leaf) / 2, pars$eT, pars$P)
    
  # Calculate Sherwood numbers
  Sh <- .get_sh(pars, surface)
  
  # Conductance in m / s  
  ret <- D_c * Sh / pars$leafsize
    
  ret %<>% 
    convert_conductance(Temp = (pars$T_air + pars$T_leaf) / 2, P = pars$P) %>%
    magrittr::use_series("umol/m^2/s/Pa")
  
  ret
  
}

#' D_x: Calculate diffusion coefficient for a given temperature and pressure
#'
#' @param D_0 Diffusion coefficient at 273.15 K (0 degree C) and 101.3246 kPa
#' @param Temp Temperature in Kelvin
#' @param eT Exponent for temperature dependence of diffusion
#' @param P Atmospheric pressure in kPa
#' 
#' @return Value in m\eqn{^2}/s of class \code{units}
#' 
#' @details 
#' 
#' \deqn{D = D_\mathrm{0} (T / 273.15) ^ {eT} (101.3246 / P)}{D = D_0 [(T / 273.15) ^ eT] (101.3246 / P)}
#' \cr
#' According to Montieth & Unger (2013), eT is generally between 1.5 and 2. Their data in Appendix 3 indicate \eqn{eT = 1.75} is reasonble for environmental physics.
#' 
#' @references 
#' 
#' Monteith JL, Unsworth MH. 2013. Principles of Environmental Physics. 4th edition. Academic Press, London.
#' 

.get_Dx <- function(D_0, Temp, eT, P) {
  
  # See Eq. 3.10 in Monteith & Unger ed. 4
  D_0 * 
    drop_units((set_units(Temp, "K") / set_units(273.15, "K"))) ^ drop_units(eT) * 
    drop_units((set_units(101.3246, "kPa") / set_units(P, "kPa")))
  
}

#' Sh: Sherwood number
#'
#' @inheritParams .get_guc
#'
#' @return A unitless number of class \code{units} 
#' 
#' @details 
#' 
#' The Sherwood number depends on a combination how much free or forced convection predominates. For mixed convection: \cr 
#' \cr
#' \deqn{Sh = (a Re ^ b) ^ {3.5} + (c Gr ^ d) ^ {3.5}) ^ {1 / 3.5}}{Sh = (a Re ^ b) ^ 3.5 + (c Gr ^ d) ^ 3.5) ^ (1 / 3.5)}
#' \cr
#' \tabular{lllll}{
#' \emph{Symbol} \tab \emph{R} \tab \emph{Description} \tab \emph{Units} \tab \emph{Default}\cr
#' \eqn{a, b, c, d} \tab \code{a, b, c, d} \tab empirical coefficients \tab none \tab \link[=make_constants]{calculated}\cr
#' \eqn{Gr} \tab \code{Gr} \tab Grashof number \tab none \tab \link[=.get_gr]{calculated}\cr
#' \eqn{Re} \tab \code{Re} \tab Reynolds number \tab none \tab \link[=.get_re]{calculated}
#' }
#' 

.get_sh <- function(pars, surface) {
  
  surface %<>% match.arg(c("lower", "upper"))
  
  Gr <- .get_gr(pars)
  Re <- .get_re(pars)
  
  D_h <- .get_Dx(pars$D_h0, (pars$T_air + pars$T_leaf) / 2, pars$eT, pars$P)
  D_c <- .get_Dx(pars$D_c0, (pars$T_air + pars$T_leaf) / 2, pars$eT, pars$P)
  
  cons <- pars$nu_constant(Re, "forced", pars$T_air, pars$T_leaf, surface)
  Nu_forced <- cons$a * drop_units(Re) ^ cons$b
  Sh_forced <- Nu_forced * drop_units(D_h / D_c) ^ drop_units(pars$sh_constant("forced"))
  
  cons <- pars$nu_constant(Re, "free", pars$T_air, pars$T_leaf, surface)
  Nu_free <- cons$a * drop_units(Gr) ^ cons$b
  Sh_free <- Nu_free * drop_units(D_h / D_c) ^ drop_units(pars$sh_constant("free"))
  
  Sh <- (Sh_forced ^ 3.5 + Sh_free ^ 3.5) ^ (1 / 3.5)
  Sh %<>% set_units()
  
  Sh
  
}

#' Re: Reynolds number
#'
#' @inheritParams .get_guc
#'
#' @return A unitless number of class \code{units} 
#' 
#' @details 
#' 
#' \deqn{Re = u d / D_\mathrm{m}}{Re = u d / D_m}
#' 
#' \tabular{lllll}{
#' \emph{Symbol} \tab \emph{R} \tab \emph{Description} \tab \emph{Units} \tab \emph{Default}\cr
#' \eqn{d} \tab \code{leafsize} \tab leaf characteristic dimension in meters \tab m \tab 0.1\cr
#' \eqn{D_\mathrm{m}}{D_m} \tab \code{D_m} \tab diffusion coefficient of momentum in air \tab m\eqn{^2} / s \tab \link[=.get_Dx]{calculated}\cr
#' \eqn{u} \tab \code{wind} \tab windspeed \tab m / s \tab 2
#' }
#' 

.get_re <- function(pars) {
  
  D_m <- .get_Dx(pars$D_m0, (pars$T_air + pars$T_leaf) / 2, pars$eT, pars$P)
  Re <- pars$wind * pars$leafsize / D_m
  
  Re
  
}

#' Gr: Grashof number
#'
#' @inheritParams .get_guc
#' 
#' @return A unitless number of class \code{units} 
#' 
#' @details 
#' 
#' \deqn{Gr = t_\mathrm{air} G d ^ 3 |T_\mathrm{v,leaf} - T_\mathrm{v,air}| / D_\mathrm{m} ^ 2}{Gr = t_air G d ^ 3 abs(Tv_leaf - Tv_air) / D_m ^ 2}
#' 
#' \tabular{lllll}{
#' \emph{Symbol} \tab \emph{R} \tab \emph{Description} \tab \emph{Units} \tab \emph{Default}\cr
#' \eqn{d} \tab \code{leafsize} \tab Leaf characteristic dimension in meters \tab m \tab 0.1\cr
#' \eqn{D_\mathrm{m}}{D_m} \tab \code{D_m} \tab diffusion coefficient of momentum in air \tab m\eqn{^2} / s \tab \link[=.get_Dx]{calculated}\cr
#' \eqn{G} \tab \code{G} \tab gravitational acceleration \tab m / s\eqn{^2} \tab 9.8\cr
#' \eqn{t_\mathrm{air}}{t_air} \tab \code{t_air} \tab coefficient of thermal expansion of air \tab 1 / K \tab 1 / Temp \cr
#' \eqn{T_\mathrm{v,air}}{Tv_air} \tab \code{Tv_air} \tab virtual air temperature \tab K \tab \link[=.get_Tv]{calculated}\cr
#' \eqn{T_\mathrm{v,leaf}}{Tv_leaf} \tab \code{Tv_leaf} \tab virtual leaf temperature \tab K \tab \link[=.get_Tv]{calculated}
#' }
#' 

.get_gr <- function(pars) {
  
  # Calculate virtual temperature
  # Assumes inside of leaf is 100% RH
  Tv_leaf <- .get_Tv(pars$T_leaf, .get_ps(pars$T_leaf, pars$P), pars$P, pars$epsilon)
  Tv_air <-	.get_Tv(pars$T_air, pars$RH * .get_ps(pars$T_air, pars$P), pars$P,
                    pars$epsilon)
  D_m <- .get_Dx(pars$D_m0, (pars$T_air + pars$T_leaf) / 2, pars$eT, pars$P)
  Gr <- (set_units(1) / pars$T_air) * pars$G * pars$leafsize ^ 3 * 
    abs(Tv_leaf - Tv_air) / D_m ^ 2
  
  Gr
  
}

#' Calculate virtual temperature
#'
#' @inheritParams .get_Dx
#' @param p water vapour pressure in kPa
#' @param epsilon ratio of water to air molar masses (unitless)
#' 
#' @return Value in K of class \code{units}
#' 
#' @details 
#' 
#' \deqn{T_\mathrm{v} = T / [1 - (1 - \epsilon) (p / P)]}{T_v = T / [1 - (1 - epsilon) (p / P)]}
#' 
#' Eq. 2.35 in Monteith & Unsworth (2013) \cr
#' \cr
#' \tabular{lllll}{
#' \emph{Symbol} \tab \emph{R} \tab \emph{Description} \tab \emph{Units} \tab \emph{Default}\cr
#' \eqn{\epsilon} \tab \code{epsilon} \tab ratio of water to air molar masses \tab unitless \tab 0.622 \cr
#' \eqn{p} \tab \code{p} \tab water vapour pressure \tab kPa \tab \link[=.get_ps]{calculated}\cr
#' \eqn{P} \tab \code{P} \tab atmospheric pressure \tab kPa \tab 101.3246
#' }
#' 
#' @references 
#' 
#' Monteith JL, Unsworth MH. 2013. Principles of Environmental Physics. 4th edition. Academic Press, London.
#' 

.get_Tv <- function(Temp, p, P, epsilon) {
  
  set_units(Temp, "K") / 
    (set_units(1) - (set_units(1) - epsilon) * (set_units(p, "kPa") / set_units(P, "kPa")))
  
}

#' Saturation water vapour pressure (kPa)
#'
#' @inheritParams .get_Dx
#'
#' @return Value in kPa of class \code{units}
#' 
#' @details 
#' 
#' Goff-Gratch equation (see http://cires1.colorado.edu/~voemel/vp.html) \cr
#' \cr
#' This equation assumes P = 1 atm = 101.3246 kPa, otherwise boiling temperature needs to change \cr
#' 
#' @references \url{http://cires1.colorado.edu/~voemel/vp.html}
#' 

.get_ps <- function(Temp, P) {
  
  # Goff-Gratch equation (see http://cires1.colorado.edu/~voemel/vp.html)
  # This assumes P = 1 atm = 101.3246 kPa, otherwise boiling temperature needs to change
  # This returns p_s in hPa
  Temp %<>% set_units("K") %>% drop_units()
  P %<>% set_units("hPa") %>% drop_units()
  p_s <- 10 ^ (-7.90298 * (373.16 / Temp - 1) +
                 5.02808 * log10(373.16 / Temp) -
                 1.3816e-7 * (10 ^ (11.344 * (1 - Temp / 373.16) - 1)) +
                 8.1328e-3 * (10 ^ (-3.49149 * (373.16 / Temp - 1)) - 1) +
                 log10(P))
  
  # Convert to kPa
  p_s %<>% 
    set_units("hPa") %>%
    set_units("kPa")
  p_s
  
}

#'  - g_mc: mesophyll conductance to CO2
#' 
#' @inheritParams .get_guc
#' 
#' @rdname CO2_conductance

.get_gmc <- function(pars, surface) {
  
  surface %<>% match.arg(c("lower", "upper"))
  
  g_mc <- switch(surface,
                 lower = pars$g_mc * (set_units(1) / (set_units(1) + pars$k_mc)),
                 upper = pars$g_mc * (pars$k_mc / (set_units(1) + pars$k_mc))
  )
  
  g_mc
  
}

#'  - g_sc: stomatal conductance to CO2
#' 
#' @inheritParams .get_guc
#' 
#' @rdname CO2_conductance

.get_gsc <- function(pars, surface) {
  
  surface %<>% match.arg(c("lower", "upper"))
  g_sc <- switch(surface,
                 lower = pars$g_sc * (set_units(1) / (set_units(1) + pars$k_sc)),
                 upper = pars$g_sc * (pars$k_sc / (set_units(1) + pars$k_sc))
  )
  
  g_sc
  
}