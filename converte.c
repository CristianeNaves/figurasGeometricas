#include <stdio.h>
#include <stdlib.h>




int main(){
	FILE* in =  fopen("butao.bmp","r+");
	FILE* out = fopen("butao.bin","w+");
	fseek(out,0,SEEK_SET);

	char aux;
	char acc;
	for (int i = 239; i > -1; --i)
	{
		fseek(in,54 + (320*i*3), SEEK_SET);
		for (int j = 0; j < 320; ++j)
		{
			fread(&aux,1,1,in);
			acc = aux >> 5;
			fread(&aux,1,1,in);
			aux = aux >> 5;
			aux = aux << 3;
			acc += aux;
			fread(&aux,1,1,in);
			aux = aux >> 6;
			aux = aux << 6;
			acc += aux;
			fwrite(&acc,1,1,out);
		}
	}
}