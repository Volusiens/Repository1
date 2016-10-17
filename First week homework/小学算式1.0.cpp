#include <iostream> 
#include <stdlib.h>
#include <time.h>
#include <stack>
#include <math.h>
#define random(x) (rand()%x+1)//产生大于0，小于或等于某一给定最大值的随机数 
using namespace std;

int GetP(char a)
{//定义优先级
    if(a=='+'||a=='-')
        return 0;
    else if(a=='*'||a=='/')
        return 1;
}

float calculate(float a, float b, char v)
{//用于中间计算 
	switch(v)
	{
		case '+':return b+a;
		case '-':return b-a;
		case '*':return b*a;
		case '/':return b/a;
	}
}

void Transform(stack<float> *A, stack<char> *B,char Oper)
{
	float a,b;//中间变量，用于计算
	char  v;//中间变量，用于计算 
    if(Oper==0)
    {
    	while(B->empty()!=1)
		{ 
			a = A->top();
			A->pop(); 
			b = A->top();
			A->pop();
			
			v = B->top();
			B->pop();
			
			A->push( calculate(a,b,v) );
		}
	}
	else
	{
	    if( B->empty()==1 || GetP(B->top()) < GetP(Oper) )
		{
			B->push(Oper);
		}
		else
		{
			a = A->top();
			A->pop(); 
			b = A->top();
			A->pop();
			v = B->top();
			B->pop();
			A->push( calculate(a,b,v) ); 
			Transform(A, B,Oper);
        }
	}
}

int main()
{
	
	stack<float> Operands;//浮点数型栈，存储操作数 
    stack<char> Operators; //字符型栈，存储操作符
	stack<float> *p1;
	stack<char> *p2;
	p1=&Operands;
	p2=&Operators;
	
	int EqNum;//算式的数量
	int Max;//算式中运算数的最大值 
	int OpNum;//每个算式中运算符的数量
	
	int Score=0;//记录用户得分 
	float RightAnswer[20];//记录算式的正确答案
	float Answer[20];//记录用户的答案
	char Oper=0;//记录中间操作符 
	 
	cout << "Please input the amount of equations." << endl;
	cin >> EqNum;
	cout << "Please input the range of the numbers in your equation." << endl << "For example: 10" << endl;
	cin >> Max;
	cout << "Please input the amount of operators in each equation." << endl << "No more than ten." << endl;
	cin >> OpNum;
	if(OpNum>10)
	{
		cout << "The amount of operators is out of range, please try again." << endl; 
		cin >> OpNum;
	}
	
	
	int i,j;
	srand( (int) time(0) );
	float a,b;//中间变量，用于计算
	char  v;//中间变量，用于计算
	
	for(i=0;i<EqNum;i++)
	{
		for(j=0;j<OpNum;j++)
		{
			p1->push(random(Max));
			cout << p1->top() << " ";
			switch(random(4))
			{
				case 1:Oper='+';break;
				case 2:Oper='-';break;
				case 3:Oper='*';break;
				case 4:Oper='/';break;
			}
			cout << Oper << " ";
			Transform(p1, p2,Oper);
			Oper=0;
		}
		p1->push(random(Max));
		cout << p1->top()  << endl;
		Transform(p1, p2,Oper);
		RightAnswer[i]=p1->top();
		p1->pop();
	}
	
	
	cout << "Do you want to deal with them?\nInput Y or N" << endl;
	char Order;
	cin >> Order;
	if(Order=='Y')
	{
		cout << "Please input your answer. Your answer should be integer or with two decimal palces." << endl << "For example: 25 7.64" << endl ;
		for(i=0;i<EqNum;i++)
		{
			cin >> Answer[i];
			if( fabs(RightAnswer[i]-Answer[i]) < 0.01 )
			{
				Score++;
			}
		}
		cout << "The right answers are : ";
		for(i=0;i<EqNum;i++)
		{
			cout << RightAnswer[i] << " ";
		}
		cout << endl << "With a precision of two decimal palces, your score is: "<< Score << endl;
	}
	else
	{
		cout << "The right answers are : ";
		for(i=0;i<EqNum;i++)
		{
			cout << RightAnswer[i] << " ";
		}
	}
	return 0;
}
