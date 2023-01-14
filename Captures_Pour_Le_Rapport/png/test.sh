for image in *.png ; 
do 
    convert "$image" -negate -monochrome ../versions\ compressees/"${image%.*}.png" ;
done
