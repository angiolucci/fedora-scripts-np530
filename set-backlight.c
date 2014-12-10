/*
 * SETBACKLIGHT
 *
 * Copyright 2013 Vinícius Angiolucci Reis
 * 
 * SETBACKLIGHT: A simple program to adjust screen brightness
 *
 * SETBACKLIGHT is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/


#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define FILE_MAX_BRI "/sys/class/backlight/intel_backlight/max_brightness"
#define FILE_CUR_BRI "/sys/class/backlight/intel_backlight/brightness"
#define MAX(a,b) ((a) > (b) ? (a) : (b))
#define MIN(a,b) ((a) < (b) ? (a) : (b))

#define MIN_BRI 0
#define STEP ( ( getMaxBri() - MIN_BRI ) / 20 )

int getCurBri(){
	FILE *pFile = NULL;
	int cur_brightness = 0;
	
	pFile = fopen(FILE_CUR_BRI, "r");
	if (pFile == NULL)
		return -1;

	fscanf(pFile, "%d", &cur_brightness);
	fclose(pFile);
	return cur_brightness;
}

int getMaxBri(){
	FILE *pFile = NULL;
	int max_brightness = 0;
	
	pFile = fopen(FILE_MAX_BRI, "r");
	if (pFile == NULL)
		return -1;

	fscanf(pFile, "%d", &max_brightness);
	fclose(pFile);
	return max_brightness;
}

void increaseBri(){
	FILE *pFile = NULL;
	int max_brightness = 0;
	int cur_brightness = 0;
    int bri_to_write = 0;
	
	max_brightness = getMaxBri();
	cur_brightness = getCurBri();
	pFile = fopen(FILE_CUR_BRI, "w");
	if (pFile == NULL)
		return;

	fscanf(pFile, "%d", &cur_brightness);
	if(cur_brightness < max_brightness){
        bri_to_write = MIN(cur_brightness + STEP, max_brightness);
		rewind(pFile);
		fprintf(pFile, "%d\n", bri_to_write );
		fclose(pFile);
	}
	return;
}

void decreaseBri(){
	FILE *pFile = NULL;
	int cur_brightness = 0;
	int bri_to_write = 0;
	
	cur_brightness = getCurBri();
	pFile = fopen(FILE_CUR_BRI, "w");
	if (pFile == NULL)
		return;

	fscanf(pFile, "%d", &cur_brightness);
	if(cur_brightness > MIN_BRI){
		bri_to_write = MAX(cur_brightness - STEP, MIN_BRI);
		rewind(pFile);
		fprintf(pFile, "%d\n", bri_to_write );
		fclose(pFile);
	}
	return;
}

void setBri(unsigned int newBrightness){
	FILE *pFile = NULL;

	pFile = fopen(FILE_CUR_BRI, "w");
	if (pFile == NULL)
		return;

	rewind(pFile);
	fprintf(pFile, "%d\n", newBrightness );
	fclose(pFile);

	return;
}

void showHelp(char *filename){
	int max_bri = getMaxBri();
	printf("Usage: %s [OPTION]\n", filename);
	printf("OPTION can be one of these:\n");
	printf("VALUE\tAn integer between %d and %d\n", MIN_BRI, max_bri);
	printf("--increase\tIncrease the screen brightness by %d\n", STEP);
	printf("--decrease\tDecrease the screen brightness by %d\n", STEP);
	printf("max\t\tSet the screen brightness to %d\n", max_bri);
    printf("med\t\tSet the screen brightness to %d\n", (max_bri - MIN_BRI) / 2 );
	printf("min\t\tSet the screen brightness to %d\n", MIN_BRI + STEP);
    printf("off\t\tShut down the screen brighteness");
	printf("\nIf OPTION is omitted, then it prints the current ");
	printf("screen brightness value.\n");
}

int main(int argc, char *argv[]){
	if (argc == 1){
		printf("%d\n", getCurBri());
	} else if (argc == 2){
		if(!strcmp(argv[1], "--increase"))
			increaseBri();
		else if (!strcmp(argv[1], "--decrease"))
			decreaseBri();
		else if (!strcmp(argv[1], "max"))
			setBri(getMaxBri());
		else if (!strcmp(argv[1], "min"))
			setBri(MIN_BRI + STEP);
        else if (!strcmp(argv[1], "med"))
            setBri((getMaxBri() - MIN_BRI) / 2);
        else if (!strcmp(argv[1], "off"))
            setBri(MIN_BRI);
		else if (!strcmp(argv[1], "--help") || !strcmp(argv[1], "-h"))
			showHelp(argv[0]);
		else if(atoi(argv[1]) >= MIN_BRI && atoi(argv[1]) <= getMaxBri())
			setBri(atoi(argv[1]));
		else
			showHelp(argv[0]);

	} else
		showHelp(argv[0]);
	
	return 0; 
}

