set outfileind [open $tempdir/temp.inp w]
      set psf $psfload
      set dcd1 $trajload
      mol load psf $psf dcd $dcd1
      set ions [atomselect top "name $cations"]
      set indexes [$ions get index] 
      puts $outfileind "$indexes"
exit

