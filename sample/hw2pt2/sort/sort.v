module sort(clk,rst,datain,dataout,over);

parameter length=8;           // the bits number of data
parameter weikuan=8;         // the length of the memory

input clk,rst;
input[length-1:0] datain;
output[length-1:0] dataout;
output over;

reg over;
reg [length-1:0] dataout;
reg [length-1:0] memo[weikuan-1:0];

integer i,j,m;

//internal
wire [length-1:0]memo_0 = memo[0];
wire [length-1:0]memo_1 = memo[1];
wire [length-1:0]memo_2 = memo[2];
wire [length-1:0]memo_3 = memo[3];
wire [length-1:0]memo_4 = memo[4];
wire [length-1:0]memo_5 = memo[5];
wire [length-1:0]memo_6 = memo[6];
wire [length-1:0]memo_7 = memo[7];


//**************数据交换任务模块************//
task exchange;
  inout[length-1:0] x,y;  
  reg[length-1:0] temp;
  
  begin
    if(x<y) begin
      temp=x;
      x=y;
      y=temp;
    end
  end
endtask
//***********************************************

always@(negedge clk or posedge rst)
  if(!rst) begin
      i=0;
      j=0;
      m=0;
      over=0;
  end else
  if(m==weikuan-1) begin //the memory is full
    m=weikuan-1;
  
    if(i==weikuan) begin//arrangement is over, set over to be  "1"
      i=weikuan;
      over=1;
    end
  
    if(i<weikuan)
      for(i=0;i<weikuan;i=i+1) begin      //then  put the datas in order
        for(j=0;j<weikuan-1-i;j=j+1) //note the range of 'j'
          exchange(memo[j+1],memo[j]); //if 'memo[j+1]<memo[j]', exchange them.
      end
  end else begin           //input the data first
    memo[m]=datain;  
    m=m+1;
  end                                    

endmodule
