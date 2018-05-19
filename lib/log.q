/ simple logging functionality

.log.o:{
  -1 string[.z.p]," | Info | ",.utl.sub x;
 };

.log.e:{
  -2 string[.z.p]," | Error | ",x:.utl.sub x;
  'x;
 };
