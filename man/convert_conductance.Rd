% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utils.R
\name{convert_conductance}
\alias{convert_conductance}
\title{Convert conductance units}
\usage{
convert_conductance(.g, Temp = NULL, P = NULL)
}
\arguments{
\item{.g}{Conductance in class units. Units must convertible to one of "m/s", "umol/m^2/s/Pa", or "mol/m^2/s"}

\item{Temp}{A temperature value of class \code{units}}

\item{P}{A pressure value of class \code{units} that is convertible to kPa}
}
\value{
A list of three values of clas \code{units} with units "m/s", "umol/m^2/s/Pa", and "mol/m^2/s".
}
\description{
Convert conductance units
}
\examples{

g_sc <- set_units(10, "m/s")
convert_conductance(g_sc, 
                    Temp = set_units(298.15, "K"), 
                    P = set_units(101.3246, "kPa"))

g_sc <- set_units(4, "umol/m^2/s/Pa")
convert_conductance(g_sc, 
                    Temp = set_units(298.15, "K"), 
                    P = set_units(101.3246, "kPa"))

g_sc <- set_units(0.4, "mol/m^2/s")
convert_conductance(g_sc, 
                    Temp = set_units(298.15, "K"), 
                    P = set_units(101.3246, "kPa"))

}
