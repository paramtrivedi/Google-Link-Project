BEGIN {

re =0;
st=10;
sp=0;
ps=0;
rp=0;
}

{

if($3 == "_1_") {
st = $2;
re = $14;
}


t=$2;

if($4 =="AGT" && $1 =="s"  && $7 =="security")
{
 if(t<st)
{
st=t;
}

}

if($4 =="AGT" && $1 =="r"  && $7 =="security")
{
 if(t>sp)
{
sp=t;
rp=rp+1;
}

}
};

END {
print "Remaining Energy of node 1 = " (re);
print "Network throughput [packet ps] =" (rp/sp-st);
};


