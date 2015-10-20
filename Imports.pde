import com.heroicrobot.controlsynthesis.*;
import com.heroicrobot.dropbit.common.*;
import com.heroicrobot.dropbit.devices.*;
import com.heroicrobot.dropbit.devices.pixelpusher.*;
import com.heroicrobot.dropbit.discovery.*;
import com.heroicrobot.dropbit.registry.*;
import processing.video.*;
import java.util.*;

DeviceRegistry registry;
TestObserver testObserver;
List<Strip> strips;

ArrayList<Segment> segments;
boolean isLoadingFromJSON =   false;
boolean segmentsLoaded =      false;
boolean displaySegments =     true;
boolean displayMap =          false;
boolean displayVideo =        true;
PVector selectedPoint =       null;

int lightStrandCounter =      0;
int numLEDsPerStripExpected = 20;
int numStripsExpected =       5;
int numStrips;

String displayText =          "";
PImage cowMap;
Movie cowMovie;