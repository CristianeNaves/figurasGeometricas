#include <stdio.h>
#include <stdlib.h>




int main(){
	FILE* in =  fopen("butao.bmp","rb");
	FILE* out = fopen("butao.bin","wb");
	fseek(out,0,SEEK_SET);

	unsigned char aux;
	unsigned char acc;
	for (int i = 239; i > -1; --i)
	{
		fseek(in,54 + (320*i*3),SEEK_SET);
		for (int j = 0; j < 320; ++j)
		{
			acc = 0;	
			fread(&aux,1,1,in);
			aux = aux >> 5;
			acc += aux << 5;
			fread(&aux,1,1,in);
			aux = aux >> 5;
			aux = aux << 2;
			acc += aux;
			fread(&aux,1,1,in);
			aux = aux >> 6;
			acc += aux;
			fwrite(&acc,1,1,out);
		}
	}

}