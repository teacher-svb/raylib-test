# Raylib from Docker

- [Raylib from Docker](#raylib-from-docker)
  - [VS Code + Docker (Native Linux)](#vs-code--docker-native-linux)
    - [1. Prerequisites](#1-prerequisites)
    - [2. Initial Setup](#2-initial-setup)
    - [3. Build \& Debug Workflow](#3-build--debug-workflow)
    - [4. Memory Leak Testing](#4-memory-leak-testing)
  - [VS Code + Docker + WSL2 (Windows)](#vs-code--docker--wsl2-windows)
    - [1. Prerequisites](#1-prerequisites-1)
    - [2. Connecting to WSL](#2-connecting-to-wsl)
    - [3. Initial Setup](#3-initial-setup)
    - [4. Build \& Debug Workflow](#4-build--debug-workflow)
  - [CLion + Docker + WSL2 Setup (Windows)](#clion--docker--wsl2-setup-windows)
    - [1. Prerequisites](#1-prerequisites-2)
    - [2. Configure the Docker Toolchain](#2-configure-the-docker-toolchain)
    - [3. CMake \& Environment](#3-cmake--environment)
    - [4. Running \& Debugging](#4-running--debugging)


## VS Code + Docker (Native Linux)

This project uses a "Pipe Transport" debugging method, allowing you to debug C++ code inside a container without leaving your local VS Code environment.

### 1. Prerequisites
* **Docker:** Ensure Docker is installed and your user is in the `docker` group (`sudo usermod -aG docker $USER`).
* **Extensions:** Install the **C/C++ Extension Pack** and **Docker** extension in VS Code.
* **XHost:** Ensure `xhost` is installed (used to grant the container display permissions).

### 2. Initial Setup
1. Copy `.env.example` to `.env`.
2. Run `id -u` and `id -g` in your terminal and update the `UID` and `GID` in your `.env` file.
3. Build the environment:
```bash
docker compose build
```

### 3. Build & Debug Workflow

- **Press F5**: Press `F5` to start the **Docker: Debug Game** configuration.
- **What happens**: 
  1. VS Code runs `xhost +local:docker` via a pre-launch task.
  2. The project is compiled inside the container using CMake.
  3. VS Code "tunnels" GDB into the container to catch your breakpoints.

### 4. Memory Leak Testing

To run Valgrind, use `Ctrl+Shift+P` -> **Tasks: Run Task** -> **Docker: Valgrind Leak Check**.

## VS Code + Docker + WSL2 (Windows)

For the best performance on Windows, this project should be stored in the WSL filesystem (e.g., `\\wsl$\Ubuntu\home\user\project`) rather than the Windows `C:\` drive.

### 1. Prerequisites
* **WSL2:** Windows 11 (or 10 with WSLg) must be updated (`wsl --update` in PowerShell).
* **Docker Desktop:** Enable **WSL 2 based engine** and **WSL Integration** for your specific distro in Docker Settings.
* **Extensions:** Install the **WSL** extension in VS Code.

### 2. Connecting to WSL
1. Open your WSL Terminal (Ubuntu, etc.).
2. Navigate to the project folder and type `code .`.
3. Ensure the bottom-left corner of VS Code displays **"WSL: [Distro Name]"**.
4. **Important:** Re-install the **C/C++ Extension** "inside" the WSL target when prompted by VS Code.

### 3. Initial Setup
1. Copy `.env.example` to `.env`.
2. For most WSL users, `UID=1000` and `GID=1000` are the correct defaults.
3. Build the environment:
```bash
docker compose build
```

### 4. Build & Debug Workflow

- **Press F5**: Press `F5` to start the **Docker: Debug Game** configuration.
- **What happens**: 
  1. VS Code runs `xhost +local:docker` via a pre-launch task.
  2. The project is compiled inside the container using CMake.
  3. VS Code "tunnels" GDB into the container to catch your breakpoints.
- **Display**: The Raylib window will appear on your Windows desktop automatically via WSLg.
- **Note**: The xhost task may show a warning/fail on Windows; this is normal and can be ignored as WSLg handles permissions differently.

## CLion + Docker + WSL2 Setup (Windows)

This project is configured to run inside a Linux container to ensure build consistency. Follow these steps to set up CLion on Windows for building and debugging.

### 1. Prerequisites
* **Docker Desktop:** Must be running with the **WSL 2 based engine** enabled.
* **WSL Integration:** In Docker Settings > Resources > WSL Integration, ensure the toggle is **ON** for your WSL distro.
* **Local Config:** Copy `.env.example` to `.env` in the project root.

### 2. Configure the Docker Toolchain
CLion will use the container's environment to compile and debug.
1. Open **Settings** (`Ctrl+Alt+S`) > **Build, Execution, Deployment** > **Toolchains**.
2. Click the **+** icon and select **Docker**.
3. In the **Image** dropdown, select `raylib-dev:latest` (ensure you have run `docker compose build` first).
4. Under **Container Settings**, click the expansion icon and add the following:
   * **Volume Mounts:**
     * Source: `/mnt/wslg` | Destination: `/mnt/wslg`
     * Source: `/tmp/.X11-unix` | Destination: `/tmp/.X11-unix`
   * **Run options:** `--network host --ipc host --device /dev/dri:/dev/dri`



### 3. CMake & Environment
1. Navigate to **Settings** > **Build, Execution, Deployment** > **CMake**.
2. Set **Build type** to `Debug`.
3. In the **Environment** field, paste exactly:
   `DISPLAY=${DISPLAY};WAYLAND_DISPLAY=${WAYLAND_DISPLAY};XDG_RUNTIME_DIR=${XDG_RUNTIME_DIR}`
4. Ensure the **Toolchain** dropdown is set to the **Docker** toolchain created in Step 2.

### 4. Running & Debugging
* **Run:** Click the **Green Play** icon in the top right.
* **Debug:** Click the **Green Bug** icon. You can set breakpoints and inspect variables natively in CLion.

> **Troubleshooting:** If the window does not appear, ensure WSLg is updated by running `wsl --update` in a Windows PowerShell.