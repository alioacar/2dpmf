set loop $loops
set k $ks
   while {$loop < $loope } {
      mol delete top
      set psf $psfload
      set dcd1 $trajload
      echo "dcd : $loop $dcd1"

      mol load psf $psf dcd $dcd1
      set nf [molinfo top get numframes]
      echo "nf $nf"
      set finalnf [expr $nf-1]
           set k [expr $k+1]
set cation [atomselect top "name $cationtype"]
animate write pdb $outputdir/$outpdbfilename beg 0 end $finalnf sel $cation 
      mol delete top
      set loop [expr $loop + 1]
}
exit
