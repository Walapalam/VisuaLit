import { lazy } from "react";
import IntroContent from "../../content/IntroContent.json";
import MiddleBlockContent from "../../content/MiddleBlockContent.json";
import AboutContent from "../../content/AboutContent.json";
import MissionContent from "../../content/MissionContent.json";
import ProductContent from "../../content/ProductContent.json";

const MiddleBlock = lazy(() => import("../../components/MiddleBlock"));
const Container = lazy(() => import("../../common/Container"));
const ScrollToTop = lazy(() => import("../../common/ScrollToTop"));
const ContentBlock = lazy(() => import("../../components/ContentBlock"));
const TeamMembers = lazy(() => import("../../components/TeamMembers"));
const StoreButtons = lazy(() => import("../../components/StoreButtons"));
const VideoPlayer = lazy(() => import("../../components/VideoPlayer"));

const teamMembers = [
  {
    image: "/img/team/amher.jpeg",
    name: "Amher Hassan",
    role: "Co - Founder",
    linkedin: "https://www.linkedin.com/in/amher-hassan-5b76621b4/"
  },
  {
    image: "/img/team/aqeel 2.png",
    name: "Aqeel Anas",
    role: "Co - Founder",
    linkedin: "https://www.linkedin.com/in/aqeel-anas-39ab88294/"
  },
  
  {
    image: "/img/team/PD.jpg",
    name: "Imad Akram",
    role: "Co - Founder",
    linkedin: "https://www.linkedin.com/in/imad-akram-361894332/"
  },
  {
    image: "/img/team/raqeeb.jpeg",
    name: "Raqeeb Rameez",
    role: "Co - Founder",
    linkedin: "https://www.linkedin.com/in/raqeeb-rameez/"
  },

 
  
  {
    image: "/img/team/usman.jpg",
    name: "Usman Masthan",
    role: "Co - Founder",
    linkedin: "https://www.linkedin.com/in/ahamed-usman-364325271/"
  },
  {
    image: "/img/team/WhatsApp Image 2025-02-23 at 10.37.49 PM.jpeg",
    name: "Vikkash Ganeshan",
    role: "Co - Founder",
    linkedin: "https://www.linkedin.com/in/vikkashganeshan/"
  }

];

const Home = () => {
  const scrollTo = (id: string) => {
    const element = document.getElementById(id);
    element?.scrollIntoView({ behavior: "smooth" });
  };

  return (
    <Container>
      <ScrollToTop />
      <div id="intro">
        <ContentBlock
          direction="right"
          title={IntroContent.title}
          content={IntroContent.text}
          button={[
            {
              ...IntroContent.button[0],
              onClick: () => scrollTo("features")
            }
          ]}
          icon="Vis.png"
          extraContent={<StoreButtons />}
          id="intro-content"
        />
      </div>
      <div id="about">
        <MiddleBlock
          title={MiddleBlockContent.title}
          content={MiddleBlockContent.text}
          
        />
      </div>
      <div id="features">
        <ContentBlock
          direction="left"
          title={AboutContent.title}
          content={AboutContent.text}
          section={AboutContent.section}
          id="features-content"
          icon={<VideoPlayer />}  // Replace icon with VideoPlayer
        />
      </div>
      <div id="team">
        <TeamMembers 
          title="Our Team"
          subtitle="Meet the amazing people behind our success"
          members={teamMembers}
        />
      </div>
    </Container>
  );
};

export default Home;
