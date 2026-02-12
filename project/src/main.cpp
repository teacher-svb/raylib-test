#include "raylib.h"

int main(void)
{
    // Initialization
    const int screenWidth = 800;
    const int screenHeight = 450;

    int x = 0;

    InitWindow(screenWidth, screenHeight, "Raylib Test - Docker Container");

    SetTargetFPS(60);

    // Main game loop
    while (!WindowShouldClose())
    {
        // Update
        // TODO: Update your variables here
        x += 1;

        // Draw
        BeginDrawing();
            ClearBackground(RAYWHITE);
            DrawText("Raylib is working in Docker!", x, 200, 20, LIGHTGRAY);
            DrawText("Press ESC to close", 280, 250, 20, GRAY);
            DrawFPS(10, 10);
        EndDrawing();
    }

    // De-Initialization
    CloseWindow();

    return 0;
}
