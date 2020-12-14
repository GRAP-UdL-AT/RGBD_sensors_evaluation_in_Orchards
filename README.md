# Matlab implementation to evaluate RGB-D sensor performance in orchard environments

## Introduction
This project is a matlab implementation to evaluate RGB-D sensor performances by analysing RGB-D data acquired in different orchard conditions. The code follows the assessment methodology presented in [1], and it was used to evaluate the performance of Microsoft Kinect v2 by using the [KEvOr dataset](http://www.grap.udl.cat/en/publications/KEvOr_dataset.html). Find more information in:
* [Assessment methodology to evaluate RGB-D sensors for 3D orchards characterization [1]](http://www.grap.udl.cat/en/publications/index.html) (submitted, not publicly available yet).

## Preparation 

First of all, create a new project folder:
```
mkdir new_project
```

Then, clone the code inside “new_project” folder:
```
cd new_project
git clone https://github.com/GRAP-UdL-AT/RGBD_sensors_evaluation_in_Orchards.git
```

### Prerequisites

* MATLAB R2020a (we have not tested it in other matlab versions)
* Computer Vision System Toolbox
* Statistics and Machine Learning Toolbox

### Data Preparation

Create a folder named “data” inside “new_project” directory.
```
mkdir data
```

Inside the “data” folder, save the folder “point_clouds” and file “data_list.csv” available at [KEvOr dataset](http://www.grap.udl.cat/en/publications/KEvOr_dataset.html).

### Launch the code

* Set the configuration parameters in `/new_project/RGBD_sensors_evaluation_in_Orchards/cfg.m` (if needed)
* Execute the file `/new_project/RGBD_sensors_evaluation_in_Orchards/main.m`


## Authorship

This project is contributed by [GRAP-UdL-AT](http://www.grap.udl.cat/en/index.html).

Please contact authors to report bugs @ jordi.genemola@udl.cat


## Citation

If you find this implementation or the analysis conducted in our report helpful, please consider citing:

    @article{Gené-Mola2020,
        Author = {{Gen{\'e}-Mola, Jordi and Llorens, Jordi and Rosell-Polo, Joan R and Gregorio, Eduard and Arn{\'o}, Jaume and Solanelles, Francesc and Mart{\'i}nez-Casasnovas, Jos{\'e} A and Escol{\`a}, Alexandre },
        Title = {Assessing the Performance of RGB-D Sensors for 3D Fruit Crop Canopy Characterization under Different Operating and Lighting Conditions },
        Journal = {Sensors},
        Year = {2020}
        doi = {https://doi.org/10.3390/s20247072}
    } 
