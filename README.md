# Vertex Animation

A small Unity project demonstrating how to animate mesh vertices directly in a vertex shader. The sample uses vertex colors to control which parts of a mesh move, as well as their timing and intensity, allowing simple creatures to be animated without a traditional skeletal rig.

This repository accompanies an article published by [Indie Games Devel](https://indiegamesdevel.com/). The link will be updated to point directly to the article once it is available.

The core technique and assets originate from a production experiment developed more than ten years ago. This repository preserves them as a practical reference rather than presenting them as a modern Unity architecture.

## Screenshots

### Original production use

![The animated spider in its original production context](Images/final%20game%20play.png)

The vertex-animated spider as it appeared in [*Panic Pump — Can you save them ALL?*](https://store.steampowered.com/app/463410/Panic_Pump__Can_you_save_them_ALL/).

### Vertex-color authoring

| Bat | Black widow |
| --- | --- |
| ![Vertex colors painted on the bat model](Images/bat%20model.png) | ![Vertex colors painted on the black-widow model](Images/spider%20model.png) |

| Black-widow side view | Result in Unity |
| --- | --- |
| ![Side view of the black-widow vertex colors](Images/spider%20model%20side.png) | ![The animated black widow in the Unity scene](Images/spider%20in%20unity.png) |

![The animated black widow on a web in the game](Images/spider%20in%20game.png)

## Included examples

- **Bat** — animates the wings in the vertex shader to create a flapping motion.
- **Black widow** — animates the spider's legs in the vertex shader. A companion C# script assigns per-instance timing and speed values and moves each spider across a surface.
- **Sample scene** — a ready-to-run scene containing both examples, their materials, lighting, and environment.

The shaders read data stored in the meshes' vertex-color channels. This data acts as a collection of masks and offsets, determining how individual vertices are displaced over time. The local mesh deformation does not require a skeletal animation system for each creature, while variations in phase and speed can be applied to individual instances.

## Project structure

```text
.
|-- Assets/VertexAnimation/
|   |-- Materials/   Materials used by the sample scene
|   |-- Models/      Bat and black-widow meshes
|   |-- Prefabs/     Ready-to-use example prefabs
|   |-- Scenes/      SampleScene and its baked lighting data
|   |-- Scripts/     Runtime movement and per-instance animation setup
|   |-- Shaders/     Bat and black-widow vertex shaders
|   `-- Textures/    Textures used by the sample assets
`-- Images/          Screenshots and vertex-color authoring references
```

## Requirements

- Unity
- Built-in Render Pipeline
- Shader Model 3.0 support

## Getting started

1. Clone or download this repository.
2. Add the project folder through Unity Hub and open it with Unity.
3. Open `Assets/VertexAnimation/Scenes/SampleScene.unity`.
4. Enter Play Mode to view the animated bats and spiders.

The sample uses CG shaders written for the Built-in Render Pipeline. Projects using a different render pipeline may require shader changes.

## How it works

Both examples calculate periodic vertex displacement from Unity's shader time. The values painted into the mesh vertex colors define which vertices are affected and introduce offsets between different parts of the model.

The black-widow example also includes `BlackWidow.cs`, which:

- assigns a randomized animation delay to each mesh instance;
- sends movement speed to the shader through vertex colors;
- chooses random destinations within the assigned surface bounds;
- rotates and moves the spider toward each destination.

This approach is useful for lightweight ambient creatures, background animation, foliage, cloth-like motion, and other effects that do not require the control of a full skeletal animation system.

## License

This project is released under the [MIT License](LICENSE).
