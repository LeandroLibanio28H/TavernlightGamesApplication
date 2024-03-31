// I had never worked with shaders before, everything I did here was learned from scratch during the test. 
// This was the activity that took me the most time; I spent about 4 days on it. 
// I'm sure there is a better way to do everything shown here, but this was the best I could do. 
// I am willing to continue studying to improve in this aspect.
// The version available in the client folder will be without comments since, with comments, it doesn't work (I don't know why).
uniform sampler2D u_Tex0; // Game map texture
uniform sampler2D u_Tex1; // Player texture
varying vec2 v_TexCoord; // Texture coordinates
uniform float u_Time; // Ellapsed time
uniform int u_PlayerLookDirection; // Player look direction

int trailCount = 5; // How many 'clones' the shader will render
float trailSeparator = 0.5;

// Direction constants
const int NORTH = 0;
const int EAST = 1;
const int SOUTH = 2;
const int WEST = 3;
vec2 directions[4] = vec2[4](vec2(0, 1), vec2(-1, 0), vec2(0, -1), vec2(1, 0)); // Direction vectors

// Get the effect start point given the player sprite size
// Almost all the values here were hardcoded; I couldn't find a proper way to position the effect on the screen.
vec2 startPointOffsetFromDirection(vec2 playerSize)
{
  if (u_PlayerLookDirection == NORTH)
  {
    return vec2(-playerSize.x - 8, -playerSize.y * trailCount * trailSeparator);
  }
  else if (u_PlayerLookDirection == EAST)
  {
    return vec2(-playerSize.x * 4.0, 8);
  }
  else if (u_PlayerLookDirection == SOUTH)
  {
    return vec2(-playerSize.x - 8, playerSize.y * 0.75);
  }
  else if (u_PlayerLookDirection == WEST)
  {
    return vec2(-playerSize.x * 0.5, 8);
  }
}

void main(void)
{
  // Get the viewport color from the texture u_Tex0 (default sampler2D uniform with the current seen map texture)
  vec4 viewportColor = texture2D(u_Tex0, v_TexCoord);
  gl_FragColor = viewportColor; // Set the output color to viewport color (nothing changes, but we save the state)

  vec2 gameSize = textureSize(u_Tex0, 0); // Get the map texture size in pixels, not fragments
  vec2 playerSize = textureSize(u_Tex1, 0); // Get the player outfit texture size in pixels, not fragments

  vec2 coord = gameSize * v_TexCoord; // Convert the current fragment coordinate to pixel coordinate (not really necessary, but i found it useful for tabletop testing)
  vec2 middle = gameSize / 2; // Get the center of the screen

  vec2 start = middle + startPointOffsetFromDirection(playerSize); // Get the effect start position
  vec2 end = start + playerSize * (vec2(1.0, 1.0) + abs(directions[u_PlayerLookDirection]) * trailCount * trailSeparator); //Get the effect end position
      //(this will always generate a rectangle with [playerSize, (playerSize * trailCount * trailSeparator) + 1] dimensions)

  if (coord.x >= start.x && coord.x <= end.x && coord.y >= start.y && coord.y <= end.y) // Check if current coordinate is inside the rectangle.
  {
    // coordinates normalized to playerSize
    float x = (coord.x - start.x) / playerSize.x;
    float y = (coord.y - start.y) / playerSize.y;
    vec4 playerColor = texture2D(u_Tex1, vec2(x, y)); playerColor
    // Saving playerColor to finalColor (we will mix it later)
    vec4 finalColor = playerColor;

    // This code aims to set the direction we need to check (when player is facing south, we need to check y)
    float directionToCheck = x;
    vec2 direction = directions[u_PlayerLookDirection];
    float addOrSubtract = direction.x;
    if (direction.x == 0)
    {
      addOrSubtract = direction.y;
      directionToCheck = y;
    }

    // Loop through trailCount and perform color mixes (making it possible to overlap trail 'clones')
    for (int i = 1; i < trailCount; i++)
    {
      if (directionToCheck > i * trailSeparator)
      {
        float offset = i * trailSeparator;
        vec2 newCoordinate = vec2(x, y) - (abs(direction) * offset); // New coordinate will be reduced by the offset making the coordinate of new trail start from 0
        vec4 newColor = texture2D(u_Tex1, newCoordinate); // Get the color of the new trail
        if (newColor.a > 0.3) // Add some alpha tolerancy, so we don't mix transparent colors
        {
          finalColor = mix(playerColor, newColor, 1.0); // Mix the color to finalColor
        }
      }
    }

    if (finalColor.a > 0.3)
    {
      gl_FragColor = vec4(mix(gl_FragColor.rgb, finalColor.rgb, 1.0), 1.0); // Set the final trailColor
    }
    return;
  }
}
