%{
	#include <stdio.h>
	#include <string.h>
	#include <stdlib.h>
	#include <ctype.h>

    int new=0;    //判断是否为新的字符串  0为新，1为旧
    int i=0,j=0;
    int index=0;     //用于记录已收录标识符的指针

    struct buffer{   					 //用于记录新的字符串元素
    	char name[100];            
    	int number;				
    };
    struct var{    						//标识符的结构体
    	struct buffer buf[10000];
    }I;
    char temp_buf_yy[100];       //接受yytext大小写处理
	char temp_buf_I[100];       //接受从I.buf中取出的字符串大小写处理

%}
%%
([ \t\n])+  {}   //退格与换行不统计

"("|")"|","|"."|"'"|"-"|"\""|"‘"|"”"|"“"|"’"|"——"|"$"|"￥"|":" {} //符号不统计

[A-Za-z][a-zA-Z0-9]{0,2}  {}//小于4个字符的不统计

[0-9]  //数字不统计


[A-Za-z][a-zA-Z0-9]{3,} { 
    strcpy(temp_buf_yy,yytext);
    for(i = 0; i < sizeof(temp_buf_yy); i++)
  		temp_buf_yy[i] = tolower(temp_buf_yy[i]);        //全部切换为小写
  	temp_buf_yy[0]=toupper(temp_buf_yy[0]);              //第一个字母大写 


	for(i=0;i<index;i++){
  		if(strcmp(I.buf[i].name,yytext)==0){   //标识符已统计并且大小写相符
  			I.buf[i].number++;
			new=1;
			break;
		}

		strcpy(temp_buf_I,I.buf[i].name);
   		for(j = 0; j < sizeof(temp_buf_I); j++)
  			temp_buf_I[j] = tolower(temp_buf_I[j]);        //全部切换为小写
  		temp_buf_I[0]=toupper(temp_buf_I[0]);              //第一个字母大写 


		if (strcmp(temp_buf_I,temp_buf_yy)==0){  //该标识符已统计并且大小写不相符
			strcpy(I.buf[i].name,temp_buf_I);
			I.buf[i].number++;
			new=1;
			break;
		}
	}
	if(new==0){
		strcpy(I.buf[index].name,yytext);
		I.buf[index].number=1;
		index++;
	}
	new=0;
}

%%

int yywrap(){
	return 1;
}


int main(int argc, char *argv[])
{
    
	int i,j,k;
	char temp_buf_1[100];      //接受统一大小写之后的字符
	char temp_buf_2[100];
	FILE * fIn;			//PL0文件的指针		

		if ((fIn = fopen(argv[1],"r")) == NULL) {
	            printf("File %s is not found.\n",argv[1]);
	            exit(1);
	        }
	    else	yyin=fIn;
      	yylex();

	fclose(fIn);

	char temp_string[100];        //排序交换载体
	int  temp_num;

	for(i=0;i<index;i++)             //冒泡排序
		for(j=i+1;j<index;j++){
			if(I.buf[j].number>I.buf[i].number){    //词频更大，上调
			     temp_num=I.buf[j].number;            
			     strcpy(temp_string,I.buf[j].name);     //交换
			     I.buf[j].number=I.buf[i].number;
			     strcpy(I.buf[j].name,I.buf[i].name);
			     I.buf[i].number=temp_num;
			     strcpy(I.buf[i].name,temp_string);
			}
			if(I.buf[j].number==I.buf[i].number){
				//首先统一成小写再比较
				strcpy(temp_buf_1,I.buf[j].name);
    			for(k = 0; k < sizeof(temp_buf_1); k++)
  					temp_buf_1[k] = tolower(temp_buf_1[k]);        //全部切换为小写

  				strcpy(temp_buf_2,I.buf[i].name);
    			for(k = 0; k < sizeof(temp_buf_2); k++)
  					temp_buf_2[k] = tolower(temp_buf_2[k]);        //全部切换为小写

				if(strcmp(temp_buf_1,temp_buf_2)<0){       //不符合字典顺序
					temp_num=I.buf[j].number;            
			     	strcpy(temp_string,I.buf[j].name);     //交换
			     	I.buf[j].number=I.buf[i].number;
			     	strcpy(I.buf[j].name,I.buf[i].name);
			     	I.buf[i].number=temp_num;
			    	strcpy(I.buf[i].name,temp_string);
				}                
			}
		}
    
    FILE *fp;
    if ((fp = fopen(argv[2],"w")) == NULL) {
	            printf("File %s is not found.\n",argv[2]);
	            exit(1);
	}
	for(j=0;j<index;j++)
	{
		fprintf(fp,"%s : %d \n",I.buf[j].name,I.buf[j].number);
	}
	fclose(fp);
	return 0;
}


