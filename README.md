# Beverage package recognition

### **Principles of Programming Languages Final Project**

#### **目錄結構**  

```
TeraData/
├── Double
├── DoubleLabel
├── DoubleList.txt
├── Readme.md
├── Single
├── SingleLabel
└── SingleList.txt
```


## **列表檔格式說明 , SingleList.txt , DoubleList.txt**  

image_file label_file  

image_file: 影像檔名  
label_file: 標籤檔名  

#### **SingleList.txt example**
```
Single/B78_IMG_9225.jpg SingleLabel/B78_IMG_9225.txt
Single/B75_IMG_9393.jpg SingleLabel/B75_IMG_9393.txt
Single/B11_IMG_0449.jpg SingleLabel/B11_IMG_0449.txt
```

####  DoubleList.txt example
```
Double/B51_B40_2.jpg DoubleLabel/B51_B40_2.txt
Double/B49_B30_2.jpg DoubleLabel/B49_B30_2.txt
Double/B89_B40_2.jpg DoubleLabel/B89_B40_2.txt
```



### **標籤檔格式說明**  

框出物體位置的四個點,順時針的點  
x1,y1,x2,y2,x3,y3,x4,y4,CLASS_LABEL  

#### **SingleLabel/B75_IMG_9393.txt example**  
```
487,1019,483,606,1007,601,1011,1015,B75
```

#### **DoubleLabel/B51_B40_2.txt example** 
```
595,950,432,433,581,385,742,901,B51
599,450,774,394,871,747,699,798,B40
```
