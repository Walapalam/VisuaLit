import styled from "styled-components";

const VideoContainer = styled.div`
  width: 100%;
  max-width: 540px;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 4px 8px rgba(143, 229, 192, 0.2);
  background: #fff;
  border: 2px solid rgb(143, 229, 192);
  transition: all 0.3s ease;
  position: relative;

  &::before {
    content: '';
    position: absolute;
    top: -2px;
    left: -2px;
    right: -2px;
    bottom: -2px;
    border-radius: 12px;
    background: rgb(143, 229, 192);
    z-index: -1;
    transition: all 0.3s ease;
    opacity: 0;
    filter: blur(8px);
  }

  &:hover {
    box-shadow: 0 6px 12px rgba(143, 229, 192, 0.3);
    transform: translateY(-2px);

    &::before {
      opacity: 0.6;
    }
  }
`;

const StyledVideo = styled.video`
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
`;

const VideoPlayer = () => {
  return (
    <VideoContainer>
      <StyledVideo
        autoPlay
        loop
        muted
        playsInline
        controls
      >
        <source src="/videos/video.mp4" type="video/mp4" />
        Your browser does not support the video tag.
      </StyledVideo>
    </VideoContainer>
  );
};

export default VideoPlayer;