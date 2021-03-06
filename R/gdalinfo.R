##' This function provides an interface mirroring that of the GDAL
##' command-line app \code{gdalinfo}. For a description of the
##' utility and the arguments that it takes, see the documentation at
##' \url{https://gdal.org/programs/gdalinfo.html}.
##'
##' @title Interface to GDAL's gdalinfo utility
##' @param datasetname Path to a GDAL-supported readable
##'     datasource.
##' @param ... Here, a placeholder argument that forces users to
##'     supply exact names of all subsequent formal arguments.
##' @param json,mm,stats,approx_stats,hist,nogcp,nomd,norat,noct
##'     See the GDAL project's
##'     \href{https://gdal.org/programs/gdalinfo.html}{gdalinfo
##'     documentation} for details.
##' @param checksum,listmdd,mdd,nofl,sd,proj4,oo,config
##'     See the GDAL project's
##'     \href{https://gdal.org/programs/gdalinfo.html}{gdalinfo
##'     documentation} for details.
##' @param dryrun Logical (default \code{FALSE}). If \code{TRUE},
##'     instead of executing the requested call to GDAL, the function
##'     will print the command-line call that would produce the
##'     equivalent output.
##' @return Silently returns path to \code{datasetname}.
##' @export
##' @author Joshua O'Brien
##' @examples
##' ff <- system.file("extdata/maunga.tif", package = "gdalUtilities")
##' gdalinfo(ff)
gdalinfo <-
    function(datasetname, ..., json, mm, stats, approx_stats, hist,
             nogcp, nomd, norat, noct, checksum, listmdd, mdd, nofl,
             sd, proj4, oo, config,
             dryrun = FALSE)
{
    ## Unlike `as.list(match.call())`, forces eval of arguments
    args <-  mget(names(match.call())[-1])
    args[c("datasetname", "dryrun")] <- NULL
    formalsTable <- getFormalsTable("gdalinfo")
    opts <- process_args(args, formalsTable)
    opts <- c("", opts) ## To ensure we never pass in a NULL

    if(dryrun) {
        x <- CLI_call("gdalinfo", datasetname, opts=opts)
        return(x)
    }

    gdal_utils("info", datasetname, options=opts)
    invisible(datasetname)
}
