# Let's Get Vysical 
This repo hosts the supplemental materials for our 2023 VIS research paper:

**Let’s Get Vysical: Perceptual Accuracy in Visual & Tactile Encodings**  
Zhongzheng Xu, Kristin Williams, and Emily Wall  
_IEEE Transactions on Visualization and Computer Graphics (TVCG, Proc. IEEE VIS'23). 2023._

## Abstract
In this paper, we explore the effectiveness of tactile data encodings using swell paper in comparison to visual encodings displayed with SVGs for data perception tasks. By replicating and adapting Cleveland and McGill's graphical perception study for the tactile modality, we establish a novel tactile encoding hierarchy. In a study with 12 university students, we found that participants perceived visual encodings more accurately when comparing values, judging their ratios with lower cognitive load, and better self-evaluated performance than tactile encodings. However, tactile encodings differed from their visual counterparts in terms of how accurately values could be decoded from them. This suggests that data physicalizations will require differing design guidance than that developed for visual encodings. By providing empirical evidence for the perceptual accuracy of tactile encodings, our work contributes to foundational research on forms of data representation that prioritize tactile perception such as tactile graphics.


## Stimuli
The `Stimuli` directory contains
- the SVGs for 6 encoding channels tested each at 6 different proportional values (+ 6 additional tabular trials, treated as a sanity check in an additional condition, not reported in the paper due to space)
- the python scripts that generate these files

This table presents the six types of visual/tactile encoding channels used in the experiment and their respective base standard values.

| Number | Encoding Channel                                  | Base Standard | Example |
|---------:|:---------------------------------------- |:------------- | :------------- |
| 1        | Position along a common scale            | 2.4 cm        | ![Position along a common scale](Stimuli/position_aligned/example.svg)
| 2        | Position along identical, non-aligned scales | 2.4 cm   | ![Position along a non-aligned scale](Stimuli/position_unaligned/example.svg)
| 3        | Length                                   | 1.2 cm        | ![Length](Stimuli/length/example.svg)
| 4        | Curvature                                | 1*            | ![Curvature](Stimuli/curvature/example.svg)
| 5        | Area                                     | 24.63 cm²     | ![Area](Stimuli/area/example.svg)
| 6        | Shading                                  | 1*            | ![Shading](Stimuli/shading/example.svg)

The asterisks (*) next to the base standard values for "curvature" and "shading" indicate that these values do not have a universal unit. For "curvature," a weighting factor of 1 is used in the Bezier curve. For "shading," a base value of 1 is used, representing the default cross-hatching pattern provided by the SVG in HTML.

### Usage

If you want to incorporate these encoding channels in your experiment or visualization project, you can use the base standard values as a reference or starting point for physical size.

## Surveys
The `Surveys` directory contains a PDF each for the pre- and post-survey questions asked to participants.

## Raw Data
The `Raw Data` directory contains a spreadsheet of the raw data for each participant.

## Data Analysis
The `Data Analysis` directory contains cleaned data and analysis scripts in a jupyter notebook. You can follow the blocks to run and inspect outputs[^1].

[^1]: The Jupyter Notebook [IEEE VIS 2023 Data Analysis.ipynb] provides the code used for data analysis during the initial submission phase. After conditional acceptance, we corrected the use of some statistical tests (which ultimately did not change our results). The R script [IEEE VIS 2023 Data Analysis(post review).R] contains the updated code used for data analysis after the paper's acceptance.

## Results
The `Results` directory contains processed data analysis files.


## Citation

```
@article{xu2023vysical,
  title={Let’s Get Vysical: Perceptual Accuracy in Visual & Tactile Encodings},
  author={Xu, Zhongzheng and Williams, Kristin and Wall, Emily},
  journal={IEEE Transactions on Visualization and Computer Graphics (TVCG)},
  year={2023},
  publisher={IEEE},
  url={todo}
}
```
