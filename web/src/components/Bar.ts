import styled, { css } from "styled-components"

interface Props {
  percent: string
}

const Bar = styled.div`
  height: 3px;
  border-radius: 2px;
  margin: 4px 0 6px;

  ${(props: Props) =>
    css`
      background: linear-gradient(
        90deg,
        #98C27D ${props.percent},
        #98C27D ${props.percent},
        #eeeeee ${props.percent},
        #eeeeee ${props.percent}
      );
    `}
`

export default Bar
